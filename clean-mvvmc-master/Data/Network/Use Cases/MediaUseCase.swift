//
//  MediaUseCase.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import Foundation

final class MediaUseCase: UseCase {
    
    lazy var repository: Repository = createRepository()
    
    
    private func createRepository() -> Repository {
        let server = Application.app.server
        let dataTransferService = server.dataTransferService
        
        return MediaRepository(dataTransferService: dataTransferService)
    }
}


extension MediaUseCase {
    
    enum Endpoints {
        case find
    }
}


extension MediaUseCase {
    
    func request<T, U>(endpoint: Endpoints,
                       request: U,
                       cached: ((T?) -> Void)?,
                       completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable? where T: Decodable, U: Decodable {
        
        switch endpoint {
        case .find:
            return repository.find(request: request,
                                   cached: cached,
                                   completion: completion)
        }
    }
    
    @available(iOS 13.0.0, *)
    func request<T, U>(endpoint: Endpoints, request: U) async -> T? where T: Decodable, U: Decodable {
        
        switch endpoint {
        case .find:
            return await repository.find(request: request)
        }
    }
}
