//
//  UserUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

final class UserUseCase: UseCase {
    
    lazy var repository: Repository = createRepository()
    
    
    private func createRepository() -> Repository {
        let server = Application.app.server
        let dataTransferService = server.dataTransferService
        
        return UserRepository(dataTransferService: dataTransferService)
    }
}


extension UserUseCase {
    
    enum Endpoints {
        case update
    }
}


extension UserUseCase {
    
    func request<T, U>(endpoint: Endpoints,
                       request: U,
                       cached: ((T?) -> Void)?,
                       completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        
        switch endpoint {
            
        case .update:
            
            let request = request as! HTTPUserDTO.Request
            let completion = completion as! (Result<HTTPUserDTO.Response, DataTransferError>) -> Void
            
            return repository.update(request: request, completion: completion)
        }
    }
    
    @available(iOS 13.0.0, *)
    func request<T, U>(endpoint: Endpoints, request: U) async -> T? where T: Decodable, U: Decodable {
        
        switch endpoint {
        case .update:
            
            let request = request as! HTTPUserDTO.Request
            
            return await repository.update(request: request)
        }
    }
}
