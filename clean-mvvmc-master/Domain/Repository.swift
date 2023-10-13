//
//  Repository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation
import URLDataTransfer

protocol RepositoryRequestable {
    
    associatedtype EndpointType
    associatedtype ResponseType: Decodable
    
    func find(request: Any?,
              cached: ((ResponseType?) -> Void)?,
              completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    func create(request: Any?,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    func update(request: Any?,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    func delete(request: Any?,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
}

extension Repository {
    
    func find(request: Any?,
              cached: ((ResponseType?) -> Void)?,
              completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func create(request: Any?,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func update(request: Any?,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func delete(request: Any?,
                completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
}


protocol Repository: RepositoryRequestable {}
