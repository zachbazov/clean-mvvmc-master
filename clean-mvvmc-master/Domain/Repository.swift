//
//  Repository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation
import URLDataTransfer

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
}


protocol Repository: RepositoryRequestable {}


extension Repository {
    
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
}
