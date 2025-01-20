//
//  URLResponseExtension.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 20/01/25.
//

import Foundation

extension HTTPURLResponse {
    func rawString(withBody body: Data?) -> String {
        var responseString = "HTTP/1.1 \(self.statusCode)\n"
        
        //Adding header fields
        for (headerField, headerValue) in self.allHeaderFields {
            responseString += "\(headerField): \(headerValue)\n"
        }
        
        //Adding body, if present
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            responseString += "\n\(bodyString)"
        }
        
        return responseString
    }
}
