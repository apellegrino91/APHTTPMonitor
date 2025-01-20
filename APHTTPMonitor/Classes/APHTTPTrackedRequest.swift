//
//  APHTTPTrackedRequest.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 15/01/25.
//


@objc public class APHTTPTrackedRequest : NSObject {
    let url : String                    //Url of the request
    let method : String                 //HTTP Method
    var id : String                     //Unique identifier, a progressive unsigned integer stringified for printing purposes
    var date : Date                     //Date of the request
    var request : URLRequest?           //URLRequest reference
    var response : HTTPURLResponse?     //HTTPURLResponse reference
    var responseData : Data?            //Body of the response as Data
    
    public init(url: String, method: String, id: String) {
        self.id = id
        self.url = url
        self.method = method
        self.date = Date() //Saving the Date.now() when a new APHTTPTrackedRequest is initialized
    }
    
    @objc func statusCode() -> Int {
        return response?.statusCode ?? 0
    }
    
    @objc func requestBodyString() -> String? {
        if let body = request?.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            return bodyString
        }
        return nil
    }
    
    @objc func responseBodyString() -> String? {
        if let body = responseData, let bodyString = String(data: body, encoding: .utf8) {
            return bodyString
        }
        return nil
    }
}

