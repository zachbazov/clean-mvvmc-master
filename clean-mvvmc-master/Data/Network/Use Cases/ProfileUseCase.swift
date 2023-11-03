//
//  ProfileUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

final class ProfileUseCase: UseCase {
    
    lazy var repository: Repository = createRepository()
    
    
    private func createRepository() -> Repository {
        let server = Application.app.server
        let dataTransferService = server.dataTransferService
        
        return ProfileRepository(dataTransferService: dataTransferService)
    }
}


extension ProfileUseCase {
    
    enum Endpoints {
        case find
        case create
        case update
        case delete
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
            
        case .create:
            
            let request = request as! HTTPProfileDTO.POST.Request
            let completion = completion as! (Result<HTTPProfileDTO.POST.Response, DataTransferError>) -> Void
            
            return repository.create(request: request, completion: completion)
            
        case .update:
            
            let request = request as! HTTPProfileDTO.PATCH.Request
            let completion = completion as! (Result<HTTPProfileDTO.PATCH.Response, DataTransferError>) -> Void
            
            return repository.update(request: request, completion: completion)
            
        case .delete:
            
            let request = request as! HTTPProfileDTO.DELETE.Request
            let completion = completion as! (Result<HTTPProfileDTO.DELETE.Response, DataTransferError>) -> Void
            
            return repository.delete(request: request, completion: completion)
        }
    }
    
    @available(iOS 13.0.0, *)
    func request<T, U>(endpoint: Endpoints, request: U) async -> T? where T: Decodable, U: Decodable {
        
        switch endpoint {
        case .find:
            
            let request = request as! HTTPProfileDTO.GET.Request
            
            return await repository.find(request: request)
            
        case .create:
            
            let request = request as! HTTPProfileDTO.POST.Request
            
            return await repository.create(request: request)
            
        case .update:
            
            let request = request as! HTTPProfileDTO.PATCH.Request
            
            return await repository.update(request: request)
            
        case .delete:
            
            let request = request as! HTTPProfileDTO.DELETE.Request
            
            return await repository.delete(request: request)
        }
    }
    
    @available(iOS 13.0.0, *)
    func request<U>(endpoint: Endpoints, request: U) async -> Void? where U: Decodable {
        
        switch endpoint {
            
        case .delete:
            
            let request = request as! HTTPProfileDTO.DELETE.Request
            
            return await repository.delete(request: request)
            
        default:
            return nil
        }
    }
}
