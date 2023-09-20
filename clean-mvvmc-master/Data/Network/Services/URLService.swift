//
//  URLService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 16/09/2023.
//

import Foundation

enum URLResponseCode: Int {
    case ok                     = 200
    case badRequest             = 400
    case unauthorized           = 401
    case notFound               = 404
    case internalServerError    = 500
}


protocol URLRequestConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

struct URLRequestConfig: URLRequestConfigurable {
    let baseURL: URL
    let headers: [String: String] = [:]
    let queryParameters: [String: String] = [:]
}


protocol URLSessionTaskCancellable {
    func cancel()
}

extension URLSessionDataTask: URLSessionTaskCancellable {}


protocol URLSessionTaskable {
    var task: URLSessionTaskCancellable? { get }
}

final class URLSessionTask: URLSessionTaskable {
    
    var task: URLSessionTaskCancellable? {
        willSet {
            task?.cancel()
        }
    }
    
    var isCancelled: Bool = false
}

extension URLSessionTask: URLSessionTaskCancellable {
    
    func cancel() {
        task?.cancel()
        
        isCancelled = true
    }
}


protocol URLSessionable {
    func request(request: URLRequest,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskCancellable
}

extension URLSession: URLSessionable {
    
    func request(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskCancellable {
        let task = dataTask(with: request, completionHandler: completion)
        
        task.resume()
        
        return task
    }
}


enum URLRequestError: Error {
    
    case error(statusCode: Int, data: Data?)
    case noInternetConnection
    case noServerConnection
    case cancelled
    case generic(Error)
    case urlGeneration
    
    
    var alteredDescription: String {
        switch self {
        case .error(let statusCode, _):
            return "Error status code: \(statusCode)."
        case .noInternetConnection:
            return "Could not connect to the internet."
        case .noServerConnection:
            return "Could not connect to the server."
        case .cancelled:
            return "Operation was cancelled."
        case .generic(let error):
            return error.localizedDescription
        case .urlGeneration:
            return "Could not generate the provided url."
        }
    }
}


private protocol URLRequestErrorResolvable {
    func resolve(error: Error) -> URLRequestError
    func resolve(requestError: Error, response: URLResponse?, with data: Data?) -> URLRequestError
}


private protocol URLRequestMongoErrorResolvable {
    
    associatedtype ResponseType: Decodable
    
    func resolve(statusCode: URLResponseCode, data: Data?) -> ResponseType?
}


private protocol URLRequestErrorLoggable {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}


protocol URLRequestable {
    func request(endpoint: Requestable,
                 error: ((HTTPMongoErrorResponseDTO) -> Void)?,
                 completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable?
    func request(request: URLRequest,
                 error: ((HTTPMongoErrorResponseDTO) -> Void)?,
                 completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable
}


struct URLService {
    
    let config: URLRequestConfigurable
    let session = URLSession.shared
    let urlErrorResolver = URLRequestErrorResolver()
    let mongoErrorResolver = URLRequestMongoErrorResolver()
    let logger = URLRequestErrorLogger()
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


struct URLRequestErrorResolver: URLRequestErrorResolvable {
    
    fileprivate func resolve(requestError: Error, response: URLResponse?, with data: Data?) -> URLRequestError {
        var urlRequestError: URLRequestError
        
        if let response = response as? HTTPURLResponse {
            urlRequestError = .error(statusCode: response.statusCode, data: data)
        } else {
            urlRequestError = resolve(error: requestError)
        }
        
        return urlRequestError
    }
    
    func resolve(error: Error) -> URLRequestError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        
        switch code {
        case .notConnectedToInternet:
            return .noInternetConnection
        case .cannotConnectToHost:
            return .noServerConnection
        case .cancelled:
            return .cancelled
        default:
            return .generic(error)
        }
    }
}


struct URLRequestMongoErrorResolver: URLRequestMongoErrorResolvable {
    
    fileprivate func resolve(statusCode: URLResponseCode, data: Data?) -> HTTPMongoErrorResponseDTO? {
        switch statusCode {
        case .unauthorized, .badRequest:
            
            if let data = data,
               let errorResponse: HTTPMongoErrorResponseDTO = decode(data) {

                return errorResponse
            }
        default:
            debugPrint(.debug, "URLService statusCode \(statusCode.rawValue)")
            
            return nil
        }
        
        return nil
    }
    
    
    private func decode(_ data: Data) -> HTTPMongoErrorResponseDTO? {
        do {
            let decoder = URLResponseDecoder()

            return try decoder.json.decode(data)
        } catch {
            debugPrint(.error, "JSON parsing error for type `\(HTTPMongoErrorResponseDTO.self)` occured at \(error.localizedDescription).")

            return nil
        }
    }
}


struct URLRequestErrorLogger: URLRequestErrorLoggable {
    
    func log(request: URLRequest) {
        debugPrint(.linebreak, "-------------")
        debugPrint(.network, "request: \(request.url!)")
        debugPrint(.network, "headers: \(request.allHTTPHeaderFields ?? [:])")
        debugPrint(.network, "method: \(request.httpMethod ?? "")")
        
        if let httpBody = request.httpBody,
           let json = (try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]),
           let result = json as [String: AnyObject]? {
            
            debugPrint(.network, "body: \(String(describing: result))")
            
        } else if let httpBody = request.httpBody,
                  let resultString = String(data: httpBody, encoding: .utf8) {
            
            debugPrint(.network, "body: \(String(describing: resultString))")
        }
    }
    
    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        
        if let dataDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            debugPrint(.network, "response: \(String(describing: dataDict))")
            debugPrint(.network, "status: \(dataDict["status"]!)")
        }
    }
    
    func log(error: Error) {
        guard let error = error as? URLRequestError else { return }
        
        switch error {
        case .noServerConnection:
            debugPrint(.error, error.alteredDescription)
        default:
            debugPrint(.error, error.localizedDescription)
        }
    }
}
