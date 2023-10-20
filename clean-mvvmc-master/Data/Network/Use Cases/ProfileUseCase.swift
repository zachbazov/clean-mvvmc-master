//
//  ProfileUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation
import URLDataTransfer

final class ProfileUseCase: UseCase {
    
    lazy var repository: ProfileRepository = createRepository()
    
    
    private func createRepository() -> ProfileRepository {
        let server = Application.app.server
        let dataTransferService = server.dataTransferService
        
        return ProfileRepository(dataTransferService: dataTransferService)
    }
}


extension ProfileUseCase {
    
    enum Endpoints {
        case find
    }
}


extension ProfileUseCase {
    
    @discardableResult
    func request(endpoint: Endpoints,
                 request: HTTPProfileDTO.GET.Request,
                 error: ((HTTPServerErrorDTO.Response) -> Void)?,
                 cached: ((HTTPProfileDTO.GET.Response?) -> Void)?,
                 completion: @escaping (Result<HTTPProfileDTO.GET.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        switch endpoint {
        case .find:
            return repository.find(request: request,
                                   cached: nil,
                                   completion: completion)
        }
    }
}
