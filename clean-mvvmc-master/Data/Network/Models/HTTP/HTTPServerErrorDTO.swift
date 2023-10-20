//
//  HTTPServerErrorDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 20/09/2023.
//

import Foundation

struct HTTPServerErrorDTO: HTTPRepresentable {
    
    typealias Request = Void
    
    struct Response: Decodable {
        let status: String
        let error: ServerErrorDTO.Response
        let message: String
    }
}


extension HTTPServerErrorDTO.Response {
    
    func toDomain() -> HTTPServerError.Response {
        return HTTPServerError.Response(status: status,
                                        error: error.toDomain(),
                                        message: message)
    }
}
