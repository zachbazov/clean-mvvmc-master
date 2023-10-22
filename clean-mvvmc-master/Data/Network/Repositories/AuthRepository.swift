//
//  AuthRepository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

struct AuthRepository: Repository {
    
    let dataTransferService: DataTransferRequestable
    
    private let responseStore = AuthResponseStore()
}


extension AuthRepository {
    
    func find<T, U>(request: U,
                    cached: ((T?) -> Void)?,
                    completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable? where T: Decodable, U: Decodable {
        
        let sessionTask = URLSessionTask()
        
        responseStore.fetcher.fetchResponse() { (result: Result<HTTPUserDTO.Response?, CoreDataError>) in
            
            if case let .success(response?) = result {
                return cached?(response as? T) ?? Void()
            }
            
            guard !sessionTask.isCancelled else { return }
            
            let endpoint = AuthRepository.signIn(with: request as! HTTPUserDTO.Request)
            
            sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        }
        
        return sessionTask
    }
    
    func create<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable? where T: Decodable, U: Decodable {
        
        let sessionTask = URLSessionTask()
        
        guard !sessionTask.isCancelled else { return nil }
        
        let endpoint = AuthRepository.signUp(with: request as! HTTPUserDTO.Request)
        
        sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        
        return sessionTask
    }
    
    func delete(completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        let sessionTask = URLSessionTask()
        
        guard !sessionTask.isCancelled else { return nil }
        
        let endpoint = AuthRepository.signOut()
        
        sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        
        return sessionTask
    }
    
    @available(iOS 13.0.0, *)
    func find<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        
        if let cached: HTTPUserDTO.Response? = responseStore.fetcher.fetchResponse() {
            return cached as? T
        }
        
        let endpoint = AuthRepository.signIn(with: request as! HTTPUserDTO.Request)
        
        let response: HTTPUserDTO.Response? = await dataTransferService.request(endpoint: endpoint)
        
        responseStore.deleter.deleteResponse()
        
        responseStore.saver.saveResponse(response, with: request)
        
        return response as? T
    }
    
    @available(iOS 13.0.0, *)
    func create<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        
        let endpoint = AuthRepository.signUp(with: request as! HTTPUserDTO.Request)
        
        let response: HTTPUserDTO.Response? = await dataTransferService.request(endpoint: endpoint)
        
        responseStore.deleter.deleteResponse()
        
        responseStore.saver.saveResponse(response, with: request)
        
        return response as? T
    }
    
    @available(iOS 13.0.0, *)
    func delete() async -> Void? {
        
        let endpoint = AuthRepository.signOut()
        
        responseStore.deleter.deleteResponse()
        
        return await dataTransferService.request(endpoint: endpoint)
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
