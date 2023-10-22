//
//  AuthUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

final class AuthUseCase: UseCase {
    
    lazy var repository: Repository = createRepository()
    
    
    private func createRepository() -> Repository {
        let server = Application.app.server
        let dataTransferService = server.dataTransferService
        
        return AuthRepository(dataTransferService: dataTransferService)
    }
}


extension AuthUseCase {
    
    enum Endpoints {
        case signIn
        case signUp
    }
}


extension AuthUseCase {
    
    @discardableResult
    func request<T, U>(endpoint: Endpoints,
                       request: U,
                       cached: ((T?) -> Void)?,
                       completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        
        let repository = repository as! AuthRepository
        
        let request = request as! HTTPUserDTO.Request
        let cached = cached as? (HTTPUserDTO.Response?) -> Void
        let completion = completion as! (Result<HTTPUserDTO.Response, DataTransferError>) -> Void
        
        switch endpoint {
        case .signIn:
            return repository.find(request: request, cached: cached, completion: completion)
            
        case .signUp:
            return repository.create(request: request, completion: completion)
        }
    }
    
    @discardableResult
    func request(completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        let repository = repository as! AuthRepository
        
        return repository.delete(completion: completion)
    }
    
    @available(iOS 13.0.0, *)
    func request<T, U>(endpoint: Endpoints, request: U) async -> T? where T: Decodable, U: Decodable {
        
        let repository = repository as! AuthRepository
        
        switch endpoint {
        case .signIn:
            return await repository.find(request: request)
            
        case .signUp:
            return await repository.create(request: request)
        }
    }
    
    @available(iOS 13.0.0, *)
    func request() async -> Void? {
        
        let repository = repository as! AuthRepository
        
        return await repository.delete()
    }
}
