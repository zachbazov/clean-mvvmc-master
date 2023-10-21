//
//  URLRequestable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

protocol URLRequestable {
    
    func request(endpoint: Routable,
                 completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable?
    
    func request(request: URLRequest,
                 completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable?
    
    
    @available(iOS 13.0.0, *)
    func request(endpoint: Routable) async throws -> (Data, URLResponse)?
    
    @available(iOS 13.0.0, *)
    func request(request: URLRequest) async throws -> (Data, URLResponse)?
}
