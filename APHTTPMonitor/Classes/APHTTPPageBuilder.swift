//
//  PageBuilder.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 20/01/25.
//

@objc class APHTTPPageBuilder : NSObject {
    let bundle : Bundle
    
    override init() {
        let frameworkBundle = Bundle(for: APHTTPMonitor.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("APHTTPMonitor.bundle")
        bundle = Bundle(url: bundleURL!)!
    }
    
    @objc func buildIndexPage(requests: [APHTTPTrackedRequest]) -> String? {
        let htmlFile = bundle.path(forResource: "index", ofType: "html")
        var htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        guard htmlString != nil else {return nil}
        
        var composedHtmlString = ""
        for req in requests {
            let row = buildIndexRow(request: req)
            if row != nil {
                composedHtmlString.append(row!)
            }
        }
        
        htmlString = htmlString!.replacingOccurrences(of: "{requests-list}", with: composedHtmlString)
        return htmlString
    }
    
    @objc func buildIndexRow(request: APHTTPTrackedRequest) -> String? {
        let rowPath = bundle.path(forResource: "row", ofType: "html")
        var htmlString = try? String(contentsOfFile: rowPath!, encoding: String.Encoding.utf8)
        guard htmlString != nil else {return nil}
        
        var statusColor = "warning"
        if (request.statusCode() != 0 && request.statusCode() >= 200 && request.statusCode() < 300) {
            statusColor = "success"
        } else if (request.statusCode() != 0 && request.statusCode() >= 400) {
            statusColor = "danger"
        }
        
        htmlString = htmlString!.replacingOccurrences(of: "{method}", with: request.method)
        htmlString = htmlString!.replacingOccurrences(of: "{status-code}", with: String(request.statusCode()))
        htmlString = htmlString!.replacingOccurrences(of: "{status-color}", with: statusColor)
        htmlString = htmlString!.replacingOccurrences(of: "{url}", with: request.url)
        htmlString = htmlString!.replacingOccurrences(of: "{row-id}", with: request.id)
        return htmlString
    }
    
    @objc func buildDetailPage(request: APHTTPTrackedRequest) -> String? {
        let detailPath = bundle.path(forResource: "detail", ofType: "html")
        var htmlString = try? String(contentsOfFile: detailPath!, encoding: String.Encoding.utf8)
        guard htmlString != nil else {return nil}
        
        htmlString = htmlString!.replacingOccurrences(of: "{row-id}", with: request.id)
        htmlString = htmlString!.replacingOccurrences(of: "{req-url}", with: request.url)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let formattedDate = formatter.string(from: request.date)
        htmlString = htmlString!.replacingOccurrences(of: "{req-time}", with: formattedDate)
        
        htmlString = htmlString!.replacingOccurrences(of: "{req-raw}", with: request.request?.rawString() ?? "")
        htmlString = htmlString!.replacingOccurrences(of: "{res-raw}", with: request.response?.rawString(withBody: request.responseData) ?? "")
        return htmlString
    }
}
