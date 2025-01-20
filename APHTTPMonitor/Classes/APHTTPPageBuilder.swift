//
//  PageBuilder.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 20/01/25.
//

@objc class APHTTPPageBuilder : NSObject {
    let bundle : Bundle             //Bundle that contain all the assets (.html files)
    var indexTemplate : String?     //index.html string with placeholders
    var indexRowTemplate : String?  //row.html string with placeholders
    var detailTemplate : String?    //detail.html string with placeholders
    
    override init() {
        //Loading bundle with all the assets (.html files)
        let frameworkBundle = Bundle(for: APHTTPMonitor.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("APHTTPMonitor.bundle")
        bundle = Bundle(url: bundleURL!)!
    }
    
    @objc func buildIndexPage(requests: [APHTTPTrackedRequest]) -> String? {
        var htmlString : String?
        
        //Loading index.html if needed
        if indexTemplate == nil {
            let htmlFilePath = bundle.path(forResource: "index", ofType: "html")
            indexTemplate = try? String(contentsOfFile: htmlFilePath!, encoding: String.Encoding.utf8)
        }
        
        htmlString = indexTemplate
        guard htmlString != nil else {return nil}
        
        var composedHtmlString = ""
        for req in requests {
            //Building request's rows
            let row = buildIndexRow(request: req)
            if row != nil {
                composedHtmlString.append(row!)
            }
        }
        
        //Replacing placeholder with all the rows previously builded
        htmlString = htmlString!.replacingOccurrences(of: "{requests-list}", with: composedHtmlString)
        return htmlString
    }
    
    @objc func buildIndexRow(request: APHTTPTrackedRequest) -> String? {
        var htmlString : String?
        
        //Loading row.html if needed
        if indexRowTemplate == nil {
            let htmlFilePath = bundle.path(forResource: "row", ofType: "html")
            indexRowTemplate = try? String(contentsOfFile: htmlFilePath!, encoding: String.Encoding.utf8)
        }

        htmlString = indexRowTemplate
        guard htmlString != nil else {return nil}
        
        //Defining color of the status code badge based on the statusCode
        var statusColor = "warning"
        if (request.statusCode() != 0 && request.statusCode() >= 200 && request.statusCode() < 300) {
            statusColor = "success"
        } else if (request.statusCode() != 0 && request.statusCode() >= 400) {
            statusColor = "danger"
        }
        
        //Replacing placeholders with all the parameters of the request
        htmlString = htmlString!.replacingOccurrences(of: "{method}", with: request.method)
        htmlString = htmlString!.replacingOccurrences(of: "{status-code}", with: String(request.statusCode()))
        htmlString = htmlString!.replacingOccurrences(of: "{status-color}", with: statusColor)
        htmlString = htmlString!.replacingOccurrences(of: "{url}", with: request.url)
        htmlString = htmlString!.replacingOccurrences(of: "{row-id}", with: request.id)
        return htmlString
    }
    
    @objc func buildDetailPage(request: APHTTPTrackedRequest) -> String? {
        var htmlString : String?
        
        //Loading detail.html if needed
        if detailTemplate == nil {
            let htmlFilePath = bundle.path(forResource: "detail", ofType: "html")
            detailTemplate = try? String(contentsOfFile: htmlFilePath!, encoding: String.Encoding.utf8)
        }
        
        htmlString = detailTemplate
        guard htmlString != nil else {return nil}
        
        //Formatting date before placeholder's replacement
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let formattedDate = formatter.string(from: request.date)
        
        //Replacing placeholders with all the parameters of the request
        htmlString = htmlString!.replacingOccurrences(of: "{req-time}", with: formattedDate)
        htmlString = htmlString!.replacingOccurrences(of: "{row-id}", with: request.id)
        htmlString = htmlString!.replacingOccurrences(of: "{req-url}", with: request.url)
        htmlString = htmlString!.replacingOccurrences(of: "{req-raw}", with: request.request?.rawString() ?? "")
        htmlString = htmlString!.replacingOccurrences(of: "{res-raw}", with: request.response?.rawString(withBody: request.responseData) ?? "")
        return htmlString
    }
}
