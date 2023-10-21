//
//  ProfileRepository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct ProfileRepository {
    
    let dataTransferService: DataTransferRequestable
}


extension ProfileRepository: Repository {
    
    func find(request: HTTPProfileDTO.GET.Request,
              cached: ((HTTPProfileDTO.GET.Response?) -> Void)?,
              completion: @escaping (Result<HTTPProfileDTO.GET.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        let sessionTask = URLSessionTask()
        
        guard !sessionTask.isCancelled else { return nil }
        
        let endpoint = ProfileRepository.find(with: request)
        
        sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        
        return sessionTask
    }
    
    func create(request: HTTPProfileDTO.GET.Request, 
                completion: @escaping (Result<HTTPProfileDTO.GET.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func update(request: HTTPProfileDTO.GET.Request, 
                completion: @escaping (Result<HTTPProfileDTO.GET.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    func delete(request: HTTPProfileDTO.GET.Request, 
                completion: @escaping (Result<HTTPProfileDTO.GET.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        return nil
    }
    
    @available(iOS 13.0.0, *)
    func find(request: HTTPProfileDTO.GET.Request) async -> HTTPProfileDTO.GET.Response? {
        
        let endpoint = ProfileRepository.find(with: request)
        let response: HTTPProfileDTO.GET.Response? = await dataTransferService.request(endpoint: endpoint)
        
        return response
    }
}


extension ProfileRepository {
    
    static func find(with request: HTTPProfileDTO.GET.Request) -> Routable {
        
        let path = "api/v1/users/profiles"
        let queryParams: [String: Any] = ["user": request.user._id ?? ""]
        
        return Endpoint(method: .get,
                        path: path,
                        queryParameters: queryParams)
    }
}
