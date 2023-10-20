//
//  ServerErrorDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 20/09/2023.
//

import Foundation

struct ServerErrorDTO: HTTPRepresentable {
    
    typealias Request = Void
    
    struct Response: Decodable {
        let statusCode: Int
        let status: String
        let isOperational: Bool
    }
}


extension ServerErrorDTO.Response {
    
    func toDomain() -> ServerError {
        return ServerError(statusCode: statusCode,
                           status: status,
                           isOperational: isOperational)
    }
}
