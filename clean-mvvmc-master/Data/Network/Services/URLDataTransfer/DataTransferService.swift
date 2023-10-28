//
//  DataTransferService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

struct DataTransferService {
    
    let urlService: URLRequestable
    let resolver = DataTransferErrorResolver()
    let logger = DataTransferErrorLogger()
}


extension DataTransferService: DataTransferRequestable {
    
    func request<T>(endpoint: Routable,
                    completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable? where T: Decodable {
        
        return urlService.request(
            endpoint: endpoint,
            completion: { result in
                
                switch result {
                case .success(let data):
                    
                    let result: Result<T, DataTransferError> = decode(data: data, decoder: endpoint.responseDecoder)
                    
                    return completion(result)
                    
                case .failure(let error):
                    
                    logger.log(error: error)
                    
                    let error = resolver.resolve(urlRequestError: error)
                    
                    return completion(.failure(error))
                }
            })
    }
    
    func request(endpoint: Routable,
                 completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable? {
        
        return urlService.request(
            endpoint: endpoint,
            completion: { result in
                
                switch result {
                case .success:
                    
                    return completion(.success(()))
                    
                case .failure(let error):
                    
                    logger.log(error: error)
                    
                    let resolvedError = resolver.resolve(urlRequestError: error)
                    
                    return completion(.failure(resolvedError))
                }
            })
    }
    
    func request<T>(endpoint: Routable) async -> T? where T: Decodable {
        
        guard let (data, _) = try? await urlService.request(endpoint: endpoint) else {
            return nil
        }
        
        let response: T? = await decode(data: data, decoder: endpoint.responseDecoder)
        
        return response
    }
    
    func request(endpoint: Routable) async -> Void? {
        
        guard let _ = try? await urlService.request(endpoint: endpoint) else {
            return nil
        }
        
        return Void()
    }
}


extension DataTransferService {
    
    private func decode<T>(data: Data?, decoder: URLResponseDecoder) -> Result<T, DataTransferError> where T: Decodable {
        
        do {
            guard let data = data else {
                return .failure(.noResponse)
            }
            
            let response: T = try decoder.json.decode(data)
            
            return .success(response)
            
        } catch {
            
            logger.log(error: error)
            
            return .failure(.parsing(error))
        }
    }
    
    private func decode<T>(data: Data?, decoder: URLResponseDecoder) async -> T? where T: Decodable {
        
        do {
            guard let data = data else {
                return nil
            }
            
            let response: T = try decoder.json.decode(data)
            
            return response
            
        } catch {
            
            logger.log(error: error)
            
            return nil
        }
    }
}
