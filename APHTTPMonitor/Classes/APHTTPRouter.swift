//
//  APHTTPRouter.swift
//  Pods
//
//  Created by Antongiulio Pellegrino on 20/01/25.
//

import Swifter

@objc class APHTTPRouter : NSObject {
    let server : HttpServer                         //Reference to the webserver started in the monitor
    private let pageBuilder = APHTTPPageBuilder()   //PageBuilder, needed in order to build the pages that the webserver will returns on every route
    
    init(server: HttpServer) {
        //Reference to the webserver
        self.server = server
    }
    
    @objc func generateMainRoute() {
        //Listening for the main route
        server["/"] = { request in
            //Building the index page
            let indexHtml = self.pageBuilder.buildIndexPage(requests: APHTTPMonitor.shared().trackedRequests)
            guard indexHtml != nil else {
                //Error building the index page
                return HttpResponse.notFound
            }
            
            //Index page successfully builded and served
            return HttpResponse.ok(.text(indexHtml!))
        }
    }
    
    @objc func generateDetailRoute(request: APHTTPTrackedRequest) {
        //Listening for a detail route. The endpoint contains the id of the tracked request
        server["/detail-" + request.id] = { httpRequest in
            //Building the detail page
            let detailhtml = self.pageBuilder.buildDetailPage(request: request)
            guard detailhtml != nil else {
                //Error building the detail page
                return HttpResponse.notFound
            }
            //Detail page successfully builded and served
            return HttpResponse.ok(.text(detailhtml!))
        }
    }
    
}
