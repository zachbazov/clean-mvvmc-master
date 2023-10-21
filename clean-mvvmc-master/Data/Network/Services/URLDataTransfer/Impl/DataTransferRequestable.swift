//
//  DataTransferRequestable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

protocol DataTransferRequestable {
    
    func request<T>(endpoint: Routable,
                    completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable? where T: Decodable
    
    func request(endpoint: Routable,
                 completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    
    
    @available(iOS 13.0.0, *)
    func request<T>(endpoint: Routable) async -> T? where T: Decodable
    
    @available(iOS 13.0.0, *)
    func request(endpoint: Routable) async -> Void?
}
