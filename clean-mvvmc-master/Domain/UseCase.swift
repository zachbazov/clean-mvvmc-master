//
//  UseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation
import URLDataTransfer

protocol UseCaseRequestable {
    
    associatedtype EndpointType
    associatedtype RequestType: Decodable
    associatedtype ErrorResponseType: Decodable
    associatedtype ResponseType: Decodable
    
    func request(endpoint: EndpointType,
                 request: RequestType,
                 error: ((ErrorResponseType) -> Void)?,
                 cached: ((ResponseType?) -> Void)?,
                 completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    
    func request(endpoint: EndpointType,
                 completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
}


extension UseCaseRequestable {
    
    func request(endpoint: EndpointType,
                 request: RequestType,
                 error: ((ErrorResponseType) -> Void)?,
                 cached: ((ResponseType?) -> Void)?,
                 completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func request(endpoint: EndpointType,
                 completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
}


protocol UseCase: UseCaseRequestable {
    
    associatedtype RepositoryType: Repository
    
    var repository: RepositoryType { get }
}
