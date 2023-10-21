//
//  Routable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation
import CodeBureau

protocol Routable {
    
    var method: HTTPMethod { get }
    var path: String { get }
    var isFullPath: Bool { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoding: BodyEndcoding { get }
    var responseDecoder: URLResponseDecoder { get }
    
    func urlRequest(with config: URLRequestConfigurable) throws -> URLRequest
}


extension Routable {
    
    private func url(with config: URLRequestConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString.last != "/" ? config.baseURL.absoluteString + "/" : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw URLRequestGenerationError.components
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
            throw URLRequestGenerationError.components
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


extension Routable {
    
    private func encodeBodyParameters(bodyParameters: [String: Any], bodyEncoding: BodyEndcoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParameters)
            
        case .stringEncodingAscii:
            return bodyParameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }
}
