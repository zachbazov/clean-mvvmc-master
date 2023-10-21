//
//  AuthRepository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

protocol AuthRoutable {
    
    associatedtype EndpointType
    associatedtype RequestType: Decodable
    associatedtype ResponseType: Decodable
    
    func sign(endpoint: EndpointType,
              request: RequestType,
              cached: ((ResponseType?) -> Void)?,
              completion: @escaping (Result<ResponseType, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    
    func sign(endpoint: EndpointType,
              completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
}


struct AuthRepository: Repository, AuthRoutable {
    
    let dataTransferService: DataTransferRequestable
    
    private let responseStore = UserResponseStore()
}


extension AuthRepository {
    
    func sign(endpoint: AuthUseCase.Endpoints,
              request: HTTPUserDTO.Request,
              cached: ((HTTPUserDTO.Response?) -> Void)?,
              completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        switch endpoint {
        case .signIn:
            
            let sessionTask = URLSessionTask()
            
            responseStore.fetcher.fetchResponse() { result in
                
                if case let .success(response?) = result {
                    return cached?(response) ?? Void()
                }
                
                guard !sessionTask.isCancelled else { return }
                
                let endpoint = AuthRepository.signIn(with: request)
                
                sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
            }
            
            return sessionTask
            
        case .signUp:
            
            let sessionTask = URLSessionTask()
            
            guard !sessionTask.isCancelled else { return nil }
            
            let endpoint = AuthRepository.signUp(with: request)
            
            sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
            
            return sessionTask
            
        default:
            return nil
        }
    }
    
    @discardableResult
    func sign(endpoint: AuthUseCase.Endpoints,
              completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        switch endpoint {
        case .signOut:
            
            let sessionTask = URLSessionTask()
            
            guard !sessionTask.isCancelled else { return nil }
            
            let endpoint = AuthRepository.signOut()
            
            sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
            
            return sessionTask
            
        default:
            return nil
        }
    }
}


extension AuthRepository {
    
    static func signIn(with request: HTTPUserDTO.Request) -> Routable {
        
        let path = "api/v1/users/signin"
        let bodyParams: [String: Any] = ["email": request.user.email ?? "",
                                         "password": request.user.password ?? ""]
        
        return Endpoint(method: .post,
                        path: path,
                        bodyParameters: bodyParams)
    }
    
    static func signUp(with request: HTTPUserDTO.Request) -> Routable {
        
        let path = "api/v1/users/signup"
        let encodedBodyParams = request.user
        
        return Endpoint(method: .post,
                        path: path,
                        bodyParametersEncodable: encodedBodyParams)
    }
    
    static func signOut() -> Routable {
        
        let path = "api/v1/users/signout"
        
        return Endpoint(method: .get, path: path)
    }
}
