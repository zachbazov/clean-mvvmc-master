//
//  URLService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 16/09/2023.
//

import Foundation

struct URLService {
    
    let configuration: URLRequestConfigurable
    let session = URLSession.shared
    let resolver = URLRequestErrorResolver()
    let logger = URLRequestLogger()
}


extension URLService: URLRequestable {
    
    func request(request: URLRequest,
                 completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable? {
        
        let dataTask = session.request(request: request) { data, response, requestError in
            
            if let requestError = requestError {
                
                let urlRequestError = resolver.resolve(requestError: requestError, response: response, with: data)
                
                logger.log(error: urlRequestError)
                
                return completion(.failure(urlRequestError))
            }
            
            logger.log(responseData: data, response: response)
            
            completion(.success(data))
        }
        
        logger.log(request: request)
        
        return dataTask
    }
    
    func request(endpoint: Routable,
                 completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable? {
        do {
            
            let urlRequest: URLRequest = try endpoint.urlRequest(with: configuration)
            
            return request(request: urlRequest, completion: completion)
            
        } catch {
            
            completion(.failure(.urlGeneration))
            
            return nil
        }
    }
    
    @available(iOS 13.0.0, *)
    func request(request: URLRequest) async throws -> (Data, URLResponse)? {
        
        logger.log(request: request)
        
        let (data, response) = try await session.data(for: request)
        
        logger.log(responseData: data, response: response)
        
        return (data, response)
    }
    
    @available(iOS 13.0.0, *)
    func request(endpoint: Routable) async throws -> (Data, URLResponse)? {
        
        let urlRequest: URLRequest = try endpoint.urlRequest(with: configuration)
        
        return try await request(request: urlRequest)
    }
}
