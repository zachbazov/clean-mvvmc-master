//
//  UseCaseRequestable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 21/10/2023.
//

import Foundation

protocol UseCaseRequestable {
    
    associatedtype EndpointType
    
    func request<T, U>(endpoint: EndpointType,
                       request: U,
                       cached: ((T?) -> Void)?,
                       completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable
    
    func request(completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    
    @available(iOS 13.0.0, *)
    func request<T, U>(endpoint: EndpointType, request: U) async -> T? where T: Decodable, U: Decodable
    
    @available(iOS 13.0.0, *)
    func request() async -> Void?
}


extension UseCaseRequestable {
    
    @discardableResult
    func request(completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func request<T, U>(endpoint: EndpointType, request: U) async -> T? where T: Decodable, U: Decodable {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func request() async -> Void? {
        return nil
    }
}
