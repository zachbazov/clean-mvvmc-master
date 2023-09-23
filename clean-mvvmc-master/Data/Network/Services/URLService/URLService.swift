//
//  URLService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 16/09/2023.
//

import Foundation
import CodeBureau

struct URLService {
    
    let config: URLRequestConfigurable
    let session = URLSession.shared
    let urlErrorResolver = URLRequestErrorResolver()
    let mongoErrorResolver = URLRequestMongoErrorResolver()
    let logger = URLRequestLogger()
}


extension URLService: URLRequestable {
    
    func request(request: URLRequest, error: ((HTTPMongoErrorResponseDTO) -> Void)?, completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable {
        
        let dataTask = session.request(request: request) { data, response, requestError in
            
            if let requestError = requestError {
                
                let urlRequestError = urlErrorResolver.resolve(requestError: requestError, response: response, with: data)
                
                logger.log(error: urlRequestError)
                
                return completion(.failure(urlRequestError))
            }
            
            if let response = response as? HTTPURLResponse,
               let statusCode = URLResponseCode(rawValue: response.statusCode) {
                
                let resolvedResponse = mongoErrorResolver.resolve(statusCode: statusCode, data: data)
                
                if let errorResponse = resolvedResponse {
                    return error?(errorResponse) ?? {}()
                }
            }
            
            logger.log(responseData: data, response: response)
            
            completion(.success(data))
        }
        
        logger.log(request: request)
        
        return dataTask
    }
    
    func request(endpoint: Requestable, error: ((HTTPMongoErrorResponseDTO) -> Void)?, completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable? {
        
        do {
            let urlRequest: URLRequest = try endpoint.urlRequest(with: config)
            
            return request(request: urlRequest, error: error, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            
            return nil
        }
    }
}
