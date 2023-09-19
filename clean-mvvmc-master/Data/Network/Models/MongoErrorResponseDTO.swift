//
//  MongoErrorResponseDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 20/09/2023.
//

import Foundation

struct MongoErrorResponseDTO: Decodable {
    
    let statusCode: Int
    let status: String
    let isOperational: Bool
}
