//
//  ProfileUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

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
    func request<T, U>(endpoint: Endpoints,
                       request: U,
                       cached: ((T?) -> Void)?,
                       completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        
        switch endpoint {
        case .find:
            let request = request as! HTTPProfileDTO.GET.Request
            let cached = cached as! (HTTPProfileDTO.GET.Response?) -> Void
            let completion = completion as! (Result<HTTPProfileDTO.GET.Response, DataTransferError>) -> Void
            
            return repository.find(request: request,
                                   cached: cached,
                                   completion: completion)
        }
    }
    
    @available(iOS 13.0.0, *)
    func request<T, U>(endpoint: Endpoints, request: U) async -> T? where T: Decodable, U: Decodable {
        switch endpoint {
        case .find:
            let request = request as! HTTPProfileDTO.GET.Request
            
            return await repository.find(request: request) as? T
        }
    }
}
