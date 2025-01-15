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
    var htmlTemplate : String?
    
    public init(url: String, method: String) {
        self.id = UUID().uuidString
        self.url = url
        self.method = method
    }
    
    @objc private func loadHTMLTemplate() {
        if (htmlTemplate != nil) { return; }
        let frameworkBundle = Bundle(for: APHTTPMonitor.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("APHTTPMonitor.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let rowPath = resourceBundle!.path(forResource: "row", ofType: "html")
        htmlTemplate = try? String(contentsOfFile: rowPath!, encoding: String.Encoding.utf8)
    }
    
    @objc public func buildHTMLRow() -> String? {
        loadHTMLTemplate()

        guard htmlTemplate != nil else {
            return nil
        }
        
        var statusColor = "warning"
        if (responseCode != nil && responseCode! >= 200 && responseCode! < 300) {
            statusColor = "success"
        } else if (responseCode != nil && responseCode! >= 400) {
            statusColor = "danger"
        }
        
        var htmlFile = htmlTemplate
        htmlFile = htmlFile!.replacingOccurrences(of: "{method}", with: method)
        htmlFile = htmlFile!.replacingOccurrences(of: "{status-code}", with: String(responseCode ?? 0))
        htmlFile = htmlFile!.replacingOccurrences(of: "{status-color}", with: statusColor)
        htmlFile = htmlFile!.replacingOccurrences(of: "{url}", with: url)
        
        return htmlFile
    }
}
