//
//  APHTTPTrackedRequest.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 15/01/25.
//


@objc public class APHTTPTrackedRequest : NSObject {
    let url : String
    let method : String
    var id : String
    var date : Date
    var request : URLRequest?
    var response : HTTPURLResponse?
    var responseData : Data?
    
    public init(url: String, method: String, id: String) {
        self.id = id
        self.url = url
        self.method = method
        self.date = Date()
    }
    
    @objc func statusCode() -> Int {
        return response?.statusCode ?? 0
    }
}

