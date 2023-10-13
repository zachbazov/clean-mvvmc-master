//
//  AuthUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation
import URLDataTransfer

struct AuthUseCase: UseCase {
    
    let repository: AuthRepository
    
    init() {
        let server = Application.app.server
        
        self.repository = AuthRepository(dataTransferService: server.dataTransferService)
    }
}


extension AuthUseCase {
    
    enum Endpoints {
        case signIn
    }
}


extension AuthUseCase {
    
    @discardableResult
    func request(endpoint: Endpoints,
                 request: HTTPUserDTO.Request,
                 error: ((HTTPMongoErrorResponseDTO) -> Void)?,
                 cached: ((HTTPUserDTO.Response?) -> Void)?,
                 completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        switch endpoint {
        case .signIn:
            return repository.sign(endpoint: endpoint,
                                   request: request,
                                   error: error,
                                   cached: cached,
                                   completion: completion)
        }
    }
}
