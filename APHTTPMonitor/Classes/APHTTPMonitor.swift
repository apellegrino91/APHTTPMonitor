//
//  APHTTPMonitor.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 15/01/25.
//

import Swifter

@objc public class APHTTPMonitor : NSObject {
    private var server : HttpServer?                            //The swifter's webserver
    public var trackedRequests : [APHTTPTrackedRequest] = []    //Array of tracked requests
    private var router : APHTTPRouter?                          //Router, needed in order to listen and serve all the routes
    
    //MARK: Constructor and singleton methods
    
    //Private static var where we initialize the monitor just the first time
    private static var _shared : APHTTPMonitor = {
        let shared = APHTTPMonitor()
        return shared
    }()
    
    //Exposed shared static method for singleton's purposes
    @objc public class func shared() -> APHTTPMonitor {
            return _shared
    }
    
    override public init() {
        super.init()
        //Setup the webserver
        setupWebServer()
    }
    
    //MARK: Server-related methods
    
    @objc private func setupWebServer() {
        //First of all let's swizzle the URLSession methods, in order to detect and track the requests
        URLSession.swizzle()
        
        //Initialization of the swifter's webserver
        server = HttpServer()
        
        guard server != nil else {
            print("[APHTTPMonitor] Error initializing webserver.")
            return
        }
        
        //Initialization of the router
        router = APHTTPRouter(server: server!)
        
        //Prepare the webserver to listen and serve the main route and the assets
        router?.generateAssets()
        router?.generateMainRoutes()
    }
    
    @objc public func start(port: Int = 3000) -> String? {
        do {
            //Starting the webserver on the port received in input, 3000 as default
            try server?.start(UInt16(port))
            
            //Printing the ip and the port in console and returning it
            let port = try server!.port()
            let addr = getWiFiAddress() ?? "127.0.0.1:3000"
            let finalUrl = addr + ":" + String(port)
            print("[APHTTPMonitor] Server started at \(finalUrl)")
            return finalUrl
        } catch {
            print("[APHTTPMonitor] Error starting webserver")
            return nil
        }
    }
    
    @objc public func stop() {
        //Stopping the webserver
        server?.stop()
        print("[APHTTPMonitor] Server stopped")
    }
    
    //MARK: Tracking methods
    
    @objc func trackRequest(req: URLRequest) -> APHTTPTrackedRequest {
        //When a new task is resumed in a URLSession, this method will be called
        //Extracting url and http method of the request
        let url = req.url!.absoluteString
        let method = req.httpMethod!
        
        //Initialize a new APHTTPTrackedRequest with the extracted data
        let trackedReq = APHTTPTrackedRequest(url: url, method: method, id: String(trackedRequests.count))
        trackedReq.request = req
        
        //Appending the initialized object in a trackedRequest's array
        trackedRequests.append(trackedReq)
        
        //Generating the route for the detail of the newly tracked request
        router?.generateDetailRoute(request: trackedReq)
        return trackedReq
    }
    
    @objc func trackResponse(response: URLResponse?, responseData: Data?, requestID: String)
    {
        //Setting the HTTPURLResponse and the response data (Data) to the APHTTPTrackedRequest
        self.trackedRequests.filter { (req) -> Bool in return req.id == requestID }.first?.response = (response as? HTTPURLResponse)
        self.trackedRequests.filter { (req) -> Bool in return req.id == requestID }.first?.responseData = responseData
    }
    
    //MARK: Utils
    
    @objc private func getWiFiAddress() -> String? {
        //Useful method, extract the local IP in order to print the correct url of the webserver
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
