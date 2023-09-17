//
//  URLService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 16/09/2023.
//

import Foundation

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
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        
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
            return "Could not generate the provider url."
        }
    }
}


protocol URLRequestErrorResolvable {
    func resolve(error: Error) -> URLRequestError
}


protocol URLRequestErrorLoggable {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}


protocol URLRequestable {
    func request(endpoint: Requestable,
                 completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable?
    func request(request: URLRequest,
                 completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable
}


struct URLService {
    
    let config: URLRequestConfigurable
    let session = URLSession.shared
    let resolver = URLRequestErrorResolver()
    let logger = URLRequestErrorLogger()
}

extension URLService: URLRequestable {
    
    func request(request: URLRequest, completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable {
        let dataTask = session.request(request: request) { data, response, error in
            if let requestError = error {
                var error: URLRequestError
                
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = resolver.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                
                completion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                
                completion(.success(data))
            }
        }
        
        logger.log(request: request)
        
        return dataTask
    }
    
    func request(endpoint: Requestable, completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLSessionTaskCancellable? {
        do {
            let urlRequest: URLRequest = try endpoint.urlRequest(with: config)
            
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            
            return nil
        }
    }
}


struct URLRequestErrorResolver: URLRequestErrorResolvable {
    
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
