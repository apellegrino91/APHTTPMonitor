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
        
        // Aggiungi gli header della risposta
        for (headerField, headerValue) in self.allHeaderFields {
            responseString += "\(headerField): \(headerValue)\n"
        }
        
        // Aggiungi il corpo della risposta, se presente
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            responseString += "\n\(bodyString)"
        }
        
        return responseString
    }
}
