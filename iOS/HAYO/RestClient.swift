//
//  RestClient.swift
//  Sheep
//
//  Created by mono on 7/30/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class RestClient {
    class var sharedInstance : RestClient {
    struct Static {
        static let instance = RestClient()
        }
        return Static.instance
    }
    let manager = AFHTTPRequestOperationManager()
    
    func get(path: String, completed: (image: UIImage?) -> ()) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: path))
        request.HTTPMethod = "GET"
        let requestOp = AFHTTPRequestOperation(request: request)
        requestOp.setCompletionBlockWithSuccess({op, response in
            let imageData = response as NSData
            let image = UIImage(data: imageData)
            completed(image: image)
            }, failure: { op, error in
                println(error)
                completed(image: nil)
            })
        manager.operationQueue.addOperation(requestOp)
    }
}