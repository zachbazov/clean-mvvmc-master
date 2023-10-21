//
//  RepositoryRequestable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 21/10/2023.
//

import Foundation

protocol RepositoryRequestable {
    
    associatedtype RequestType: Decodable
    associatedtype ResponseType: Decodable
    
    func find(request: RequestType,
              cached: ((ResponseType?) -> Void)?,
              completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    
    func create(request: RequestType,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    
    func update(request: RequestType,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    
    func delete(request: RequestType,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    
    @available(iOS 13.0.0, *)
    func find(request: RequestType) async -> ResponseType?
    
    @available(iOS 13.0.0, *)
    func create(request: RequestType) async -> ResponseType?
    
    @available(iOS 13.0.0, *)
    func update(request: RequestType) async -> ResponseType?
    
    @available(iOS 13.0.0, *)
    func delete(request: RequestType) async -> ResponseType?
}


extension RepositoryRequestable {
    
    func find(request: RequestType,
              cached: ((ResponseType?) -> Void)?,
              completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func create(request: RequestType,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func update(request: RequestType,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func delete(request: RequestType,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func find(request: RequestType) async -> ResponseType? {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func create(request: RequestType) async -> ResponseType? {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func update(request: RequestType) async -> ResponseType? {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func delete(request: RequestType) async -> ResponseType? {
        return nil
    }
}
