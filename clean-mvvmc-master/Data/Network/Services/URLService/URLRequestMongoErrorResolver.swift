//
//  URLRequestMongoErrorResolver.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation
import CodeBureau

struct URLRequestMongoErrorResolver: URLRequestMongoErrorResolvable {
    
    func resolve(statusCode: URLResponseCode, data: Data?) -> HTTPMongoErrorResponseDTO? {
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
