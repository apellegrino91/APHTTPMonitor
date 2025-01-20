//
//  APHTTPMonitor.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 15/01/25.
//

import Swifter

@objc public class APHTTPMonitor : NSObject {
    private var server : HttpServer?                            //The swifter's webserver
    public var trackedRequests : [APHTTPTrackedRequest] = []   //Array of tracked requests
    private var router : APHTTPRouter?
    
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
    
    @objc public func start(port: Int = 3000) -> String? {
        do {
            try server?.start(UInt16(port))
            let port = try server!.port()
            let addr = getWiFiAddress() ?? "127.0.0.1:3000"
            let finalUrl = addr + ":" + String(port)
            print("Server started at \(finalUrl)")
            return finalUrl
        } catch {
            print("Error starting webserver")
            return nil
        }
    }
    
    @objc public func stop() {
        server?.stop()
        print("Server stopped")
    }
    
    @objc private func setupWebServer() {
        URLSession.swizzle()
        server = HttpServer()
        
        guard server != nil else {
            print("Error initializing webserver.")
            return
        }
        
        router = APHTTPRouter(server: server!)
        router?.generateMainRoute()
    }
    
    @objc func trackRequest(req: URLRequest) -> APHTTPTrackedRequest {
        let url = req.url!.absoluteString
        let method = req.httpMethod!
        
        let trackedReq = APHTTPTrackedRequest(url: url, method: method, id: String(trackedRequests.count))
        trackedReq.request = req
        
        trackedRequests.append(trackedReq)
        router?.generateDetailRoute(request: trackedReq)
        return trackedReq
    }
    
    @objc func trackResponse(response: URLResponse?, responseData: Data?, requestID: String)
    {
        self.trackedRequests.filter { (req) -> Bool in return req.id == requestID }.first?.response = (response as? HTTPURLResponse)
        self.trackedRequests.filter { (req) -> Bool in return req.id == requestID }.first?.responseData = responseData
    }
    
    //MARK: Utils
    
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
}
