import Foundation
import UIKit
import PromiseKit

func fetch<T>(methodName: String, parameters: NSDictionary, body: ((T) -> (), (NSError) -> (), AnyObject) -> ()) -> Promise<T> {
    return Promise<T> { fulfiller, rejunker in
        PFCloud.callFunctionInBackground(methodName, withParameters: parameters, block: { result, error in
            func rejecter(error: NSError) {
                let info = error.userInfo != nil ? NSMutableDictionary(dictionary: error.userInfo) : NSMutableDictionary()
                rejunker(NSError(domain:error.domain, code:error.code, userInfo:info))
            }
            if error != nil {
                rejecter(error)
            } else {
                body(fulfiller, rejecter, result!)
            }
        })
    }
}


extension PFCloud {

    class func callFunction(methodName: String, parameters: NSDictionary) -> Promise<AnyObject> {
        return promise(methodName, parameters: parameters)
    }
    class func callFunction(methodName: String, parameters: NSDictionary) -> Promise<String> {
        return promise(methodName, parameters: parameters)
    }
    class func promise<T>(methodName: String, parameters: NSDictionary) -> Promise<T> {
        return fetch(methodName, parameters) { (fulfiller, rejecter, data) in
            if let casted = data as? T {
                fulfiller(casted)
                return
            }
            self.rejectByCast(rejecter)
        }
    }
    class func rejectByCast(rejecter: (NSError) -> ()) {
        let info = [NSLocalizedDescriptionKey: "The server returned repsonse was not textual"]
        rejecter(NSError(domain:NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo:info))
    }
}
