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
    var headers : [String:Any]?
    var body : Data?
    var response : String?
    var responseCode : Int?
    
    public init(url: String, method: String) {
        self.id = UUID().uuidString
        self.url = url
        self.method = method
    }
}
