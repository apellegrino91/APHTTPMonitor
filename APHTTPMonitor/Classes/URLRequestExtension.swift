//
//  URLRequestExtension.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 20/01/25.
//

import Foundation

extension URLRequest {
    func rawString() -> String {
        var requestString = "\(self.httpMethod ?? "GET") \(self.url?.path ?? "") HTTP/1.1\n"
        
        if let host = self.url?.host {
            requestString += "Host: \(host)\n"
        }
        
        //Adding request's headers
        for (headerField, headerValue) in self.allHTTPHeaderFields ?? [:] {
            requestString += "\(headerField): \(headerValue)\n"
        }
        
        //Adding body if present
        if let httpBody = self.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            requestString += "\n\(bodyString)"
        }
        
        return requestString
    }
}
