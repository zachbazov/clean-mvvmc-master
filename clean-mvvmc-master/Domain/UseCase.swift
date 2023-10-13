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
}


protocol UseCase: UseCaseRequestable {
    
    associatedtype RepositoryType: Repository
    
    var repository: RepositoryType { get }
}
