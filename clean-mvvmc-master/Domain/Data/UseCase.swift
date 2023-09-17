//
//  UseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

protocol UseCaseRequestable {
    
    associatedtype E
    associatedtype ResponseType where ResponseType: Decodable
    
    func request(endpoint: E,
                 request: Any?,
                 cached: ((ResponseType?) -> Void)?,
                 completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
}


protocol UseCase: UseCaseRequestable {
    
    associatedtype RepositoryType: Repository
    
    var repository: RepositoryType { get }
}
