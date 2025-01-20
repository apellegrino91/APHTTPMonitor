//
//  APHTTPTrackedRequest.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 15/01/25.
//

public extension URLSession {
    
    @objc static func swizzle() {
        let selector = #selector((URLSession.dataTask(with:completionHandler:)) as (URLSession) -> (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask)
        
        let m1 = class_getInstanceMethod(URLSession.self, selector)
        let m2 = class_getInstanceMethod(URLSession.self, #selector(URLSession.swizzled_dataTask(req:completionHandler:)))
        
        if m1 == nil || m2 == nil
        {
            print("[APHTTPMonitor] Swizzling failed")
        }
        
        if let m1 = m1, let m2 = m2 { method_exchangeImplementations(m1, m2) }
    }
    
    @objc dynamic func swizzled_dataTask(req: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let trackedReq = APHTTPMonitor.shared().trackRequest(req: req)
        var newCompletion : (Data?, URLResponse?, Error?) -> Void
        newCompletion = { respData, response, error in
            APHTTPMonitor.shared().trackResponse(response: response, responseData: respData, requestID: trackedReq.id)
            completionHandler(respData,response,error)
        }
        
        return swizzled_dataTask(req: req, completionHandler: newCompletion)
    }
}
