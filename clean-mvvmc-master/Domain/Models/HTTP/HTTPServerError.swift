//
//  HTTPServerError.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct HTTPServerError: HTTPRepresentable {
    
    typealias Request = Void
    
    struct Response {
        let status: String
        let error: ServerError
        let message: String
    }
}
