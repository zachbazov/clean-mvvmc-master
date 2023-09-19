//
//  AuthRepository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

protocol AuthRequestable {
    
    associatedtype EndpointType
    associatedtype RequestType: Decodable
    associatedtype ErrorResponseType: Decodable
    associatedtype ResponseType: Decodable
    
    func sign(endpoint: EndpointType,
              request: RequestType,
              error: ((ErrorResponseType) -> Void)?,
              cached: ((ResponseType?) -> Void)?,
              completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
}


struct AuthRepository: Repository, AuthRequestable {
    
    let dataTransferService = MongoService.shared.dataTransferService
}


extension AuthRepository {
    
    func sign(endpoint: AuthUseCase.Endpoints,
              request: HTTPUserDTO.Request,
              error: ((HTTPMongoErrorResponseDTO) -> Void)?,
              cached: ((HTTPUserDTO.Response?) -> Void)?,
              completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        switch endpoint {
        case .signIn:
            let responseStore = UserResponseStore()
            let sessionTask = URLSessionTask()
            
            responseStore.fetchResponse(for: request) { result in
                
                if case let .success(response?) = result {
                    return cached?(response) ?? {}()
                }
                
                guard !sessionTask.isCancelled else { return }
                
                let endpoint = AuthRepository.signIn(with: request)
                
                sessionTask.task = dataTransferService.request(endpoint: endpoint,
                                                               withErrorHandler: error,
                                                               completion: completion)
            }
            
            return sessionTask
        }
    }
}


extension AuthRepository {
    
    func find(request: Any?,
              cached: ((HTTPUserDTO.Response?) -> Void)?,
              completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func create(request: Any?, completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func update(request: Any?, completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func delete(request: Any?, completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
}


extension AuthRepository {
    
    static func signIn(with request: HTTPUserDTO.Request) -> Endpoint {
        guard let email = request.user.email,
              let password = request.user.password
        else { fatalError() }
        
        let path = "api/v1/users/signin"
        let bodyParams: [String: Any] = ["email": email, "password": password]
        
        return Endpoint(method: .post, path: path, bodyParameters: bodyParams)
    }
}
