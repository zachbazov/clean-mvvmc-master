//
//  URLRequestMongoErrorResolver.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation
import CodeBureau
import URLDataTransfer

struct URLRequestMongoErrorResolver: URLRequestMongoErrorResolvable {
    
    func resolve(statusCode: URLResponseCode, data: Data?) -> HTTPServerErrorDTO.Response? {
        switch statusCode {
        case .unauthorized, .badRequest:
            
            if let data = data,
               let errorResponse: HTTPServerErrorDTO.Response = decode(data) {

                return errorResponse
            }
        default:
            debugPrint(.debug, "URLService statusCode \(statusCode.rawValue)")
            
            return nil
        }
        
        return nil
    }
    
    
    private func decode(_ data: Data) -> HTTPServerErrorDTO.Response? {
        do {
            let decoder = URLResponseDecoder()

            return try decoder.json.decode(data)
        } catch {
            debugPrint(.error, "JSON parsing error for type `\(HTTPServerErrorDTO.Response.self)` occured at \(error.localizedDescription).")

            return nil
        }
    }
}
