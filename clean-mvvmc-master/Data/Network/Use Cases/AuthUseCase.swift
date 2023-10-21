//
//  AuthUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

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
    func request<T, U>(endpoint: Endpoints,
                       request: U,
                       cached: ((T?) -> Void)?,
                       completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        
        switch endpoint {
        case .signIn, .signUp:
            let request = request as! HTTPUserDTO.Request
            let cached = cached as? (HTTPUserDTO.Response?) -> Void
            let completion = completion as! (Result<HTTPUserDTO.Response, DataTransferError>) -> Void
            
            return repository.sign(endpoint: endpoint,
                                   request: request,
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
