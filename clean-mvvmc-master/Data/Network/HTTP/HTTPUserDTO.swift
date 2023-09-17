//
//  HTTPUserDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

final class HTTPUserDTO: HTTPRepresentable {
    
    struct Request: Decodable {
        let user: UserDTO
    }
    
    
    struct Response: Decodable {
        var status: String
        var token: String
        var data: UserDTO
    }
}
