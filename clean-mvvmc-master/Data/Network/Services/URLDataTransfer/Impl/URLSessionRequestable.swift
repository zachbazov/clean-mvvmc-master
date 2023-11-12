//
//  URLSessionRequestable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

protocol URLSessionRequestable {
    
    func request(request: URLRequest,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskCancellable
    
    @available(iOS 13.0.0, *)
    func request(_ request: URLRequest) async throws -> (Data, URLResponse)?
}


extension URLSession: URLSessionRequestable {
    
    func request(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskCancellable {
        
        let task = dataTask(with: request, completionHandler: completion)
        
        task.resume()
        
        return task
    }
    
    @available(iOS 13.0.0, *)
    func request(_ request: URLRequest) async throws -> (Data, URLResponse)? {
        return try? await URLSession.shared.data(for: request)
    }
}
