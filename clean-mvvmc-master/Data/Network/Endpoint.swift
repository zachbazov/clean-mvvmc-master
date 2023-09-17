//
//  Endpoint.swift
//  clean-mvvmc-master
//
//  Created by Developer on 16/09/2023.
//

import Foundation

protocol Requestable {
    var method: HTTPMethod { get }
    var path: String { get }
    var isFullPath: Bool { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoding: BodyEndcoding { get }
    
    func urlRequest(with config: URLRequestConfigurable) throws -> URLRequest
}


protocol ResponseDecodable {
    var responseDecoder: URLResponseDecoder? { get }
}


typealias ResponseRequestable = Requestable & ResponseDecodable


struct Endpoint: ResponseRequestable {
    
    var method: HTTPMethod
    var path: String
    var isFullPath: Bool = false
    var headerParameters: [String : String] = .jsonContentType
    var queryParametersEncodable: Encodable?
    var queryParameters: [String : Any] = [:]
    var bodyParametersEncodable: Encodable?
    var bodyParameters: [String : Any] = [:]
    var bodyEncoding: BodyEndcoding = .jsonSerializationData
    
    var responseDecoder: URLResponseDecoder?
}


enum HTTPMethod: String {
    case get    = "GET"
    case head   = "HEAD"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}


enum BodyEndcoding {
    case jsonSerializationData
    case stringEncodingAscii
}


enum RequestGenerationError: Error {
    case components
}


extension Requestable {
    private func url(with config: URLRequestConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString.last != "/" ? config.baseURL.absoluteString + "/" : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw RequestGenerationError.components
        }
        
        var urlQueryItems: [URLQueryItem] = []
        
        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        
        queryParameters.forEach {
            let queryItem = URLQueryItem(name: $0.key, value: "\($0.value)")
            urlQueryItems.append(queryItem)
        }
        
        config.queryParameters.forEach {
            let queryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlQueryItems.append(queryItem)
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else {
            throw RequestGenerationError.components
        }
        
        return url
    }
    
    func urlRequest(with config: URLRequestConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var headers = config.headers
        
        headerParameters.forEach {
            headers.updateValue($1, forKey: $0)
        }
        
        let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBodyParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding)
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
}


extension Requestable {
    private func encodeBodyParameters(bodyParameters: [String: Any], bodyEncoding: BodyEndcoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParameters)
        case .stringEncodingAscii:
            return bodyParameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }
}


private extension Encodable {
    
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data)
        
        return json as? [String: Any]
    }
}


private extension Dictionary {
    
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

private extension Dictionary where Key == String, Value == String {
    
    static var jsonContentType: [String: String] {
        return ["content-type": "application/json"]
    }
    
    
    mutating func setHeader(_ key: String, _ value: String) {
        self[key] = value
    }
    
    mutating func removeHeader(_ key: String) {
        self.removeValue(forKey: key)
    }
}
