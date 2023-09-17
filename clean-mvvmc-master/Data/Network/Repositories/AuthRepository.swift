//
//  AuthRepository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

final class AuthRepository: Repository {
    
    let dataTransferService = MongoService.shared.dataTransferService
}


extension AuthRepository {
    
    func sign(endpoint: AuthUseCase.E,
              request: Any?,
              cached: ((HTTPUserDTO.Response?) -> Void)?,
              completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        switch endpoint {
        case .signIn:
            guard let request = request as? HTTPUserDTO.Request else { return nil }
            
            let sessionTask = URLSessionTask()
            
            guard !sessionTask.isCancelled else { return nil }
            
            let endpoint = AuthRepository.signIn(with: request)
            
            sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
            
            return sessionTask
        }
    }
}


extension AuthRepository {
    
    static func signIn(with request: HTTPUserDTO.Request) -> Endpoint<HTTPUserDTO.Response> {
        guard let email = request.user.email,
              let password = request.user.password
        else { fatalError() }
        
        let path = "api/v1/users/signin"
        let bodyParams: [String: Any] = ["email": email, "password": password]
        
        return Endpoint(method: .post, path: path, bodyParameters: bodyParams)
    }
}
