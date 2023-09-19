//
//  HTTPMongoErrorResponseDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 20/09/2023.
//

import Foundation

struct HTTPMongoErrorResponseDTO: Decodable {
    
    var status: String
    var error: MongoErrorResponseDTO
    var message: String
}
