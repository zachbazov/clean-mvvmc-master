//
//  URLResponseCode.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

enum URLResponseCode: Int {
    
    case ok                     = 200
    case badRequest             = 400
    case unauthorized           = 401
    case notFound               = 404
    case internalServerError    = 500
}
