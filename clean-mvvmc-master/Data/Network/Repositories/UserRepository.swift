//
//  UserRepository.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct UserRepository {
    
    let dataTransferService: DataTransferRequestable
}


extension UserRepository: Repository {
    
    func update<T, U>(request: U,
                      completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable? where T: Decodable, U: Decodable {
        
        let sessionTask = URLSessionTask()
        
        guard !sessionTask.isCancelled else {
            return nil
        }
        
        let request = request as! HTTPUserDTO.Request
        let endpoint = UserRepository.updateUserData(with: request)
        
        sessionTask.task = dataTransferService.request(endpoint: endpoint, completion: completion)
        
        return sessionTask
    }
    
    @available(iOS 13.0.0, *)
    func update<T, U>(request: U) async -> T? where T: Decodable, U: Decodable {
        
        let request = request as! HTTPUserDTO.Request
        let endpoint = UserRepository.updateUserData(with: request)
        
        return await dataTransferService.request(endpoint: endpoint)
    }
}


extension UserRepository {
    
    static func updateUserData(with request: HTTPUserDTO.Request) -> Routable {
        
        let path = "api/v1/users"
        let bodyParams: [String: Any] = ["name": request.user.name ?? "",
                                         "selectedProfile": request.selectedProfile ?? ""]
        
        return Endpoint(method: .patch,
                        path: path,
                        bodyParameters: bodyParams)
    }
}
