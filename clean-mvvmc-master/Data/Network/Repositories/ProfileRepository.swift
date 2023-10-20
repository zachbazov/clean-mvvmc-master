//
//  ProfileRepository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation
import URLDataTransfer

struct ProfileRepository {
    
    var dataTransferService: DataTransferService
}


extension ProfileRepository: Repository {
    
    func find(request: HTTPProfileDTO.GET.Request,
              cached: ((HTTPProfileDTO.GET.Response?) -> Void)?,
              completion: @escaping (Result<HTTPProfileDTO.GET.Response, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        let sessionTask = URLSessionTask()
        
        guard !sessionTask.isCancelled else { return nil }
        
        let endpoint = ProfileRepository.find(with: request)
        
        sessionTask.task = dataTransferService.request(
            endpoint: endpoint,
            error: nil,
            completion: completion)
        
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
}


extension ProfileRepository {
    
    static func find(with request: HTTPProfileDTO.GET.Request) -> Endpoint {
        
        let path = "api/v1/users/profiles"
        let queryParams: [String: Any] = ["user": request.user._id ?? ""]
        
        return Endpoint(method: .get,
                        path: path,
                        queryParameters: queryParams)
    }
}
