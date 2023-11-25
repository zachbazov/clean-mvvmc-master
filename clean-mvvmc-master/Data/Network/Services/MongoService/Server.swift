//
//  Server.swift
//  clean-mvvmc-master
//
//  Created by Developer on 16/09/2023.
//

import Foundation

final class Server {
    
    private(set) lazy var hostProvider: ServerHostProvidable = createHostProvider()
    
    lazy var dataTransferService: DataTransferRequestable = createDataTransferService()
    
    lazy var authService: AuthRequestable = createAuthService()
    
    lazy var imageService: URLImageService = createImageService()
    
    
    weak var delegate: ServerDelegate? {
        didSet {
            delegate?.serverDidLaunch(self)
        }
    }
}


extension Server {
    
    private func createHostProvider() -> ServerHostProvidable {
        return ServerHostProvider()
    }
    
    private func createDataTransferService() -> DataTransferRequestable {
        guard let url = URL(string: hostProvider.absoluteString) else { fatalError() }
        
        let requestConfiguration = URLRequestConfiguration(baseURL: url)
        let urlService = URLService(configuration: requestConfiguration)
        
        return DataTransferService(urlService: urlService)
    }
    
    private func createAuthService() -> AuthRequestable {
        return AuthService()
    }
    
    private func createImageService() -> URLImageService {
        return URLImageService()
    }
}
