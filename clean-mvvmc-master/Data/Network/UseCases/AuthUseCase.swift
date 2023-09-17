//
//  AuthUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

final class AuthUseCase: UseCase {
    
    enum Endpoints {
        case signIn
    }
    
    
    let repository = AuthRepository()
}


extension AuthUseCase {
    
    @discardableResult
    func request(endpoint: Endpoints,
                 request: Any?,
                 cached: ((HTTPUserDTO.Response?) -> Void)?,
                 completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        switch endpoint {
        case .signIn:
            return repository.sign(endpoint: endpoint, request: request, cached: cached, completion: completion)
        }
    }
}
