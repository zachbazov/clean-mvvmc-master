//
//  RepositoryRequestable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 21/10/2023.
//

import Foundation

protocol RepositoryRequestable {
    
    func find<T, U>(request: U,
                    cached: ((T?) -> Void)?,
                    completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable
    
    func create<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable
    
    func update<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable
    
    func delete<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable
    
    func delete(completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    
    @available(iOS 13.0.0, *)
    func find<T, U>(request: U) async -> T? where T: Decodable, U: Decodable
    
    @available(iOS 13.0.0, *)
    func create<T, U>(request: U) async -> T? where T: Decodable, U: Decodable
    
    @available(iOS 13.0.0, *)
    func update<T, U>(request: U) async -> T? where T: Decodable, U: Decodable
    
    @available(iOS 13.0.0, *)
    func delete<T, U>(request: U) async -> T? where T: Decodable, U: Decodable
    
    @available(iOS 13.0.0, *)
    func delete() async -> Void?
}


extension RepositoryRequestable {
    
    func find<T, U>(request: U,
                    cached: ((T?) -> Void)?,
                    completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        return nil
    }
    
    func create<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        return nil
    }
    
    func update<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        return nil
    }
    
    func delete<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        return nil
    }
    
    func delete(completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func find<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func create<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func update<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func delete<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func delete() async -> Void? {
        return nil
    }
}
