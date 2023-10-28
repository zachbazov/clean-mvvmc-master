//
//  SectionRepository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import Foundation

struct SectionRepository: Repository {
    
    let dataTransferService: DataTransferRequestable
    
    private let responseStore = SectionResponseStore()
}


extension SectionRepository {
    
    func find<T, U>(request: U,
                    cached: ((T?) -> Void)?,
                    completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable? where T: Decodable, U: Decodable {
        
        let sessionTask = URLSessionTask()
        
        responseStore.fetcher.fetchResponse { (result: Result<HTTPSectionDTO.Response?, CoreDataError>) in
            
            if case let .success(response?) = result {
                return cached?(response as? T) ?? Void()
            }
            
            guard !sessionTask.isCancelled else {
                return
            }
            
            let request = request as! HTTPSectionDTO.Request
            let endpoint = SectionRepository.find(with: request)
            
            sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        }
        
        return sessionTask
    }
    
    @available(iOS 13.0.0, *)
    func find<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        
        if let cached: HTTPSectionDTO.Response? = responseStore.fetcher.fetchResponse() {
            return cached as? T
        }
        
        let request = request as! HTTPSectionDTO.Request
        let endpoint = SectionRepository.find(with: request)
        
        let response: HTTPSectionDTO.Response? = await dataTransferService.request(endpoint: endpoint)
        
        responseStore.deleter.deleteResponse()
        
        responseStore.saver.saveResponse(response, with: request)
        
        return response as? T
    }
}


extension SectionRepository {
    
    static func find(with request: HTTPSectionDTO.Request) -> Routable {
        
        let path = "api/v1/sections"
        let queryParams: [String: Any] = ["sort": "id"]
        
        return Endpoint(method: .get,
                        path: path,
                        queryParameters: queryParams)
    }
}
