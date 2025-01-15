//
//  APHTTPTrackedRequest.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 15/01/25.
//

public extension URLSession {
    
    @objc public dynamic func swizzled_dataTask(req: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let trackedReq = APHTTPMonitor.shared().trackRequest(req: req)
        var newCompletion : (Data?, URLResponse?, Error?) -> Void
        newCompletion = { respData, response, error in
            
            var responseString = ""
            if respData != nil
            {
                responseString = String(data: respData!, encoding: String.Encoding.utf8) ?? "Unable to parse body"
            }
            
            let responseCode = (response is HTTPURLResponse) ? (response as! HTTPURLResponse).statusCode : 0
            
            APHTTPMonitor.shared().trackResponse(code: responseCode, body: responseString, requestID: trackedReq.id)
            completionHandler(respData,response,error)
        }
        
        return swizzled_dataTask(req: req, completionHandler: newCompletion)
    }
}
