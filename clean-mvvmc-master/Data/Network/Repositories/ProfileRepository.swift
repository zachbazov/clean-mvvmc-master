//
//  ProfileRepository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct ProfileRepository {
    
    let dataTransferService: DataTransferRequestable
    
    private let responseStore = ProfileResponseStore()
}


extension ProfileRepository: Repository {
    
    func find<T, U>(request: U,
                    cached: ((T?) -> Void)?,
                    completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        
        let sessionTask = URLSessionTask()
        
        responseStore.fetcher.fetchResponse() { (result: Result<HTTPProfileDTO.GET.Response?, CoreDataError>) in
            
            if case let .success(response?) = result {
                return cached?(response as? T) ?? Void()
            }
            
            guard !sessionTask.isCancelled else {
                return
            }
            
            let endpoint = ProfileRepository.find(with: request as! HTTPProfileDTO.GET.Request)
            
            sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        }
        
        return sessionTask
    }
    
    func create<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        
        let sessionTask = URLSessionTask()
        
        guard !sessionTask.isCancelled else { return nil }
        
        let endpoint = ProfileRepository.create(with: request as! HTTPProfileDTO.POST.Request)
        
        sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        
        return sessionTask
    }
    
    func update<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        
        let sessionTask = URLSessionTask()
        
        guard !sessionTask.isCancelled else { return nil }
        
        let endpoint = ProfileRepository.update(with: request as! HTTPProfileDTO.PATCH.Request)
        
        sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        
        return sessionTask
    }
    
    func delete<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, U: Decodable {
        
        let sessionTask = URLSessionTask()
        
        guard !sessionTask.isCancelled else { return nil }
        
        let endpoint = ProfileRepository.delete(with: request as! HTTPProfileDTO.DELETE.Request)
        
        sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        
        return sessionTask
    }
    
    @available(iOS 13.0.0, *)
    func find<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        
        if let cached: HTTPProfileDTO.GET.Response? = responseStore.fetcher.fetchResponse() {
            return cached as? T
        }
        
        let endpoint = ProfileRepository.find(with: request as! HTTPProfileDTO.GET.Request)
        let response: HTTPProfileDTO.GET.Response? = await dataTransferService.request(endpoint: endpoint)
        
        responseStore.saver.saveResponse(response)
        
        return response as? T
    }
    
    @available(iOS 13.0.0, *)
    func create<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        
        let endpoint = ProfileRepository.create(with: request as! HTTPProfileDTO.POST.Request)
        let response: HTTPProfileDTO.POST.Response? = await dataTransferService.request(endpoint: endpoint)
        
        return response as? T
    }
    
    @available(iOS 13.0.0, *)
    func update<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        
        let endpoint = ProfileRepository.update(with: request as! HTTPProfileDTO.PATCH.Request)
        let response: HTTPProfileDTO.PATCH.Response? = await dataTransferService.request(endpoint: endpoint)
        
        return response as? T
    }
    
    @available(iOS 13.0.0, *)
    func delete<U>(request: U) async -> Void? where U: Decodable {
        
        let endpoint = ProfileRepository.delete(with: request as! HTTPProfileDTO.DELETE.Request)
        let response: Void? = await dataTransferService.request(endpoint: endpoint)
        
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
    
    static func create(with request: HTTPProfileDTO.POST.Request) -> Routable {
        
        let path = "api/v1/users/profiles"
        let queryParams: [String: Any] = ["user": request.user._id ?? ""]
        let bodyParams: [String: Any] = ["name": request.profile.name,
                                         "image": request.profile.image]
        
        return Endpoint(method: .post,
                        path: path,
                        queryParameters: queryParams,
                        bodyParameters: bodyParams)
    }
    
    static func update(with request: HTTPProfileDTO.PATCH.Request) -> Routable {
        
        let path = "api/v1/users/profiles"
        let queryParams: [String: Any] = ["user": request.user._id ?? "",
                                          "id": request.id ?? ""]
        let encodedBodyParams = request.profile
        
        return Endpoint(method: .patch,
                        path: path,
                        queryParameters: queryParams,
                        bodyParametersEncodable: encodedBodyParams)
    }
    
    static func delete(with request: HTTPProfileDTO.DELETE.Request) -> Routable {
        
        let path = "api/v1/users/profiles"
        let queryParams: [String: Any] = ["user": request.user._id ?? "",
                                          "id": request.id]
        
        return Endpoint(method: .delete,
                        path: path,
                        queryParameters: queryParams)
    }
}
