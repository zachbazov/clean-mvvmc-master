//
//  AuthUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation
import URLDataTransfer

final class AuthUseCase: UseCase {
    
    lazy var repository: AuthRepository = createRepository()
    
    
    private func createRepository() -> AuthRepository {
        let server = Application.app.server
        let dataTransferService = server.dataTransferService
        
        return AuthRepository(dataTransferService: dataTransferService)
    }
}


extension AuthUseCase {
    
    enum Endpoints {
        case signIn
        case signUp
        case signOut
    }
}


extension AuthUseCase {
    
    @discardableResult
    func request(endpoint: Endpoints,
                 request: HTTPUserDTO.Request,
                 error: ((HTTPServerErrorDTO.Response) -> Void)?,
                 cached: ((HTTPUserDTO.Response?) -> Void)?,
                 completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        switch endpoint {
        case .signIn, .signUp:
            return repository.sign(endpoint: endpoint,
                                   request: request,
                                   error: error,
                                   cached: cached,
                                   completion: completion)
        default:
            return nil
        }
    }
    
    @discardableResult
    func request(endpoint: Endpoints,
                 completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        switch endpoint {
        case .signOut:
            return repository.sign(endpoint: endpoint, completion: completion)
            
        default:
            return nil
        }
    }
}
