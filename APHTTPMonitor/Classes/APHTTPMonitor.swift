//
//  APHTTPMonitor.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 15/01/25.
//

import Swifter

@objc public class APHTTPMonitor : NSObject {
    private var server : HttpServer?                            //The swifter's webserver
    private var trackedRequests : [APHTTPTrackedRequest] = []   //Array of tracked requests
    
    //MARK: Constructor and singleton methods
    
    private static var _shared : APHTTPMonitor = {
        let shared = APHTTPMonitor()
        return shared
    }()
    
    @objc public class func shared() -> APHTTPMonitor {
            return _shared
    }
    
    override public init() {
        super.init()
        setupWebServer()
    }
    
    //MARK: Server-related methods
    
    @objc public func start() {
        do {
            try server?.start(3000)
            let port = try server!.port()
            let addr = getWiFiAddress() ?? "127.0.0.1:3000"
            print("Server started at \(addr):\(port)")
        } catch {
            print("Error starting webserver")
        }
    }
    
    @objc public func stop() {
        server?.stop()
    }
    
    @objc private func setupWebServer() {
        swizzleURLSession()
        server = HttpServer()
        
        guard server != nil else {
            print("Error initializing webserver.")
            return
        }
        
        server!["/httpmonitor"] = { request in
            var htmlString = self.retrieveHtmlTemplate()
            var composedHtmlString = ""
            
            for req in self.trackedRequests {
                let row = req.buildHTMLRow()
                if row != nil {
                    composedHtmlString.append(row!)
                }
            }
            
            htmlString = htmlString!.replacingOccurrences(of: "{requests-list}", with: composedHtmlString)
            return HttpResponse.ok(.text(htmlString!))
        }
    }
    
    @objc func trackRequest(req: URLRequest) -> APHTTPTrackedRequest {
        let url = req.url!.absoluteString
        let method = req.httpMethod!
        let headers = req.allHTTPHeaderFields
        let body = req.httpBody
        
        let trackedReq = APHTTPTrackedRequest(url: url, method: method)
        trackedReq.headers = headers
        trackedReq.body = body
        
        trackedRequests.append(trackedReq)
        return trackedReq
    }
    
    @objc func trackResponse(code: Int, body: String, requestID: String)
    {
        self.trackedRequests.filter { (req) -> Bool in return req.id == requestID }.first?.response = body
        self.trackedRequests.filter { (req) -> Bool in return req.id == requestID }.first?.responseCode = code
    }
    
    //MARK: Utils
    
    @objc private func swizzleURLSession() {
        let selector = #selector((URLSession.dataTask(with:completionHandler:)) as (URLSession) -> (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask)
        
        let m1 = class_getInstanceMethod(URLSession.self, selector)
        let m2 = class_getInstanceMethod(URLSession.self, #selector(URLSession.swizzled_dataTask(req:completionHandler:)))
        
        if m1 == nil || m2 == nil
        {
            print("Swizzling failed")
        }
        
        if let m1 = m1, let m2 = m2 { method_exchangeImplementations(m1, m2) }
    }
    
    @objc private func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    @objc private func retrieveHtmlTemplate() -> String? {
        let frameworkBundle = Bundle(for: APHTTPMonitor.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("APHTTPMonitor.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let htmlFile = resourceBundle!.path(forResource: "index", ofType: "html")
        return try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
    }
}
