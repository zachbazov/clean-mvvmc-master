//
//  UserUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation
import URLDataTransfer

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
    
    func request(endpoint: Endpoints,
                 request: HTTPUserDTO.Request,
                 error: ((HTTPServerErrorDTO.Response) -> Void)?,
                 cached: ((HTTPUserDTO.Response?) -> Void)?,
                 completion: @escaping (Result<HTTPUserDTO.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        switch endpoint {
        case .find:
            return repository.find(request: request,
                                   cached: nil,
                                   completion: completion)
        }
    }
}
