//
//  UserUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

final class UserUseCase: UseCase {
    
    lazy var repository: UserRepository = createRepository()
    
    
    private func createRepository() -> UserRepository {
        let server = Application.app.server
        let dataTransferService = server.dataTransferService
        
        return UserRepository(dataTransferService: dataTransferService)
    }
}


extension UserUseCase {
    
    enum Endpoints {
        case find
    }
}


extension UserUseCase {
    
    func request<T, U>(endpoint: Endpoints,
                       request: U,
                       cached: ((T?) -> Void)?,
                       completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        
        switch endpoint {
        case .find:
            let request = request as! HTTPUserDTO.Request
            let completion = completion as! (Result<HTTPUserDTO.Response, DataTransferError>) -> Void
            
            return repository.find(request: request,
                                   cached: nil,
                                   completion: completion)
        }
    }
}
