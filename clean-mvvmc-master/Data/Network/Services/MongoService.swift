//
//  MongoService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 16/09/2023.
//

import Foundation


private protocol MongoHostProvidable {
    var absoluteString: String { get }
}


final class MongoService {
    
    static var shared = MongoService()
    
    
    private let provider = MongoHostProvider()
    
    private lazy var urlService: URLService = createURLService()
    
    lazy var dataTransferService: DataTransferService = createDataTransferService()
    
    let authService = AuthService()
    
    
    private init() {}
}

extension MongoService {
    
    private func createURLService() -> URLService {
        guard let url = URL(string: provider.absoluteString) else { fatalError() }
        
        let requestConfig = URLRequestConfiguration(baseURL: url)
        
        return URLService(config: requestConfig)
    }
    
    private func createDataTransferService() -> DataTransferService {
        return DataTransferService(urlService: urlService)
    }
}


struct MongoHostProvider: MongoHostProvidable {
    
    private var host: String {
        guard let host = Bundle.main.object(forInfoDictionaryKey: "API Host") as? String else {
            fatalError("API Host must be set on the property list file.")
        }
        
        return host
    }
    
    private var scheme: String {
        guard let scheme = Bundle.main.object(forInfoDictionaryKey: "API Scheme") as? String else {
            fatalError("API Scheme must be set on the property list file.")
        }
        
        return scheme
    }
    
    
    var absoluteString: String {
        return scheme + "://" + host
    }
}
