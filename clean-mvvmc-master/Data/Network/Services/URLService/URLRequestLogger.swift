//
//  URLRequestLogger.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation
import CodeBureau

struct URLRequestLogger: URLRequestLoggable {
    
    func log(request: URLRequest) {
        debugPrint(.linebreak, "-------------")
        debugPrint(.network, "request: \(request.url!)")
        debugPrint(.network, "headers: \(request.allHTTPHeaderFields ?? [:])")
        debugPrint(.network, "method: \(request.httpMethod ?? "")")
        
        if let httpBody = request.httpBody,
           let json = (try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]),
           let result = json as [String: AnyObject]? {
            
            debugPrint(.network, "body: \(String(describing: result))")
            
        } else if let httpBody = request.httpBody,
                  let resultString = String(data: httpBody, encoding: .utf8) {
            
            debugPrint(.network, "body: \(String(describing: resultString))")
        }
    }
    
    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        
        if let dataDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            debugPrint(.network, "response: \(String(describing: dataDict))")
            debugPrint(.network, "status: \(dataDict["status"]!)")
        }
    }
    
    func log(error: Error) {
        guard let error = error as? URLRequestError else { return }
        
        switch error {
        case .noServerConnection:
            debugPrint(.error, error.alteredDescription)
        default:
            debugPrint(.error, error.localizedDescription)
        }
    }
}
