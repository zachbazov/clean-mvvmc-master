//
//  MediaRepository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import Foundation

struct MediaRepository: Repository {
    
    let dataTransferService: DataTransferRequestable
    
    private let responseStore = MediaResponseStore()
}


extension MediaRepository {
    
    func find<T, U>(request: U,
                    cached: ((T?) -> Void)?,
                    completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable? where T: Decodable, U: Decodable {
        
        let sessionTask = URLSessionTask()
        
        responseStore.fetcher.fetchResponse { (result: Result<HTTPMediaDTO.Response?, CoreDataError>) in
            
            if case let .success(response?) = result {
                return cached?(response as? T) ?? Void()
            }
            
            guard !sessionTask.isCancelled else {
                return
            }
            
            let request = request as! HTTPMediaDTO.Request
            let endpoint = MediaRepository.find(with: request)
            
            sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        }
        
        return sessionTask
    }
    
    @available(iOS 13.0.0, *)
    func find<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        
        if let cached: HTTPMediaDTO.Response? = responseStore.fetcher.fetchResponse() {
            return cached as? T
        }
        
        let request = request as! HTTPMediaDTO.Request
        let endpoint = MediaRepository.find(with: request)
        
        let response: HTTPMediaDTO.Response? = await dataTransferService.request(endpoint: endpoint)
        
        responseStore.deleter.deleteResponse()
        
        responseStore.saver.saveResponse(response)
        
        return response as? T
    }
}


extension MediaRepository {
    
    static func find(with request: HTTPMediaDTO.Request) -> Routable {
        
        let path = "api/v1/media"
        
        return Endpoint(method: .get, path: path)
    }
}
