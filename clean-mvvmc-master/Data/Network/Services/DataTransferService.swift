//
//  DataTransferService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case requestFailure(URLRequestError)
    case resolvedRequestFailure(Error)
}


protocol DataTransferErrorResolvable {
    func resolve(urlRequestError error: URLRequestError) -> DataTransferError
}


protocol DataTransferErrorLoggable {
    func log(error: Error)
}


protocol DataTransferRequestable {
    func request<T, E>(endpoint: E,
                       withErrorHandler error: ((HTTPMongoErrorResponseDTO) -> Void)?,
                       completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable,
          E: ResponseRequestable
    
    func request<E>(endpoint: E,
                    completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where E: ResponseRequestable
}


protocol URLResponseDecodable {
    func decode<T>(_ data: Data) throws -> T where T: Decodable
}


struct DataTransferService {
    
    let urlService: URLService
    let resolver = DataTransferErrorResolver()
    let logger = DataTransferErrorLogger()
    let decoder = URLResponseDecoder()
}

extension DataTransferService: DataTransferRequestable {
    
    func request<T, E>(endpoint: E,
                       withErrorHandler error: ((HTTPMongoErrorResponseDTO) -> Void)?,
                       completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where T: Decodable, E: ResponseRequestable {
        
        return urlService.request(
            endpoint: endpoint,
            withErrorHandler: error,
            completion: { result in
                switch result {
                case .success(let data):
                    let result: Result<T, DataTransferError> = decode(data: data, decoder: decoder)
                    
                    return completion(result)
                case .failure(let error):
                    logger.log(error: error)
                    
                    let error = resolver.resolve(urlRequestError: error)
                    
                    return completion(.failure(error))
                }
            })
    }
    
    func request<E>(endpoint: E,
                    completion: @escaping (Result<Void, DataTransferError>) -> Void) -> URLSessionTaskCancellable?
    where E: ResponseRequestable {
        
        return urlService.request(
            endpoint: endpoint,
            withErrorHandler: nil,
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
}


extension DataTransferService {
    
    private func decode<T>(data: Data?, decoder: URLResponseDecoder) -> Result<T, DataTransferError> where T: Decodable {
        do {
            guard let data = data else { return .failure(.noResponse) }
            
            let response: T = try decoder.json.decode(data)
            
            return .success(response)
        } catch {
            logger.log(error: error)
            
            return .failure(.parsing(error))
        }
    }
}


struct DataTransferErrorResolver: DataTransferErrorResolvable {
    
    func resolve(urlRequestError error: URLRequestError) -> DataTransferError {
        let resolvedError = resolve(error: error)
        
        return resolvedError is URLRequestError ? .requestFailure(error) : .resolvedRequestFailure(resolvedError)
    }
    
    
    private func resolve(error: URLRequestError) -> Error {
        let code = URLError.Code(rawValue: (error as NSError).code)
        
        switch code {
        default:
            return error
        }
    }
}


struct DataTransferErrorLogger: DataTransferErrorLoggable {
    
    func log(error: Error) {
        debugPrint(.linebreak, "------------")
        debugPrint(.error, error.localizedDescription)
    }
}


struct URLResponseDecoder {
    
    let json = JSON()
    let rawData = RawData()
    
    
    struct JSON: URLResponseDecodable {
        
        private let decoder = JSONDecoder()
        
        func decode<T>(_ data: Data) throws -> T where T: Decodable {
            return try decoder.decode(T.self, from: data)
        }
    }
    
    
    struct RawData: URLResponseDecodable {
        
        enum CodingKeys: String, CodingKey {
            case `default` = ""
        }
        
        
        func decode<T>(_ data: Data) throws -> T where T: Decodable {
            if T.self is Data.Type, let data = data as? T {
                
                return data
                
            } else {
                let context = DecodingError.Context(codingPath: [CodingKeys.default],
                                                    debugDescription: "Expected `Data` type.")
                
                throw DecodingError.typeMismatch(T.self, context)
            }
        }
    }
}
