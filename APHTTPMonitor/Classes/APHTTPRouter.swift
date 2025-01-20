//
//  APHTTPRouter.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 20/01/25.
//

import Swifter

@objc class APHTTPRouter : NSObject {
    let server : HttpServer
    private let pageBuilder = APHTTPPageBuilder()
    
    init(server: HttpServer) {
        self.server = server
    }
    
    @objc func generateMainRoute() {
        server["/httpmonitor"] = { request in
            let indexHtml = self.pageBuilder.buildIndexPage(requests: APHTTPMonitor.shared().trackedRequests)
            guard indexHtml != nil else {
                return HttpResponse.notFound
            }
            return HttpResponse.ok(.text(indexHtml!))
        }
    }
    
    @objc func generateDetailRoute(request: APHTTPTrackedRequest) {
        server["/detail-" + request.id] = { httpRequest in
            let detailhtml = self.pageBuilder.buildDetailPage(request: request)
            guard detailhtml != nil else {
                return HttpResponse.notFound
            }
            return HttpResponse.ok(.text(detailhtml!))
        }
    }
    
}
