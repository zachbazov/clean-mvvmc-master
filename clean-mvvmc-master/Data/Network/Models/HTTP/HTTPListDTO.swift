//
//  HTTPListDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct ListHTTPDTO {
    
    struct GET {
        
        struct Request: Decodable {
            let user: UserDTO
            var media: [MediaDTO]?
        }
        
        
        struct Response: Decodable {
            let status: String
            var data: [ListDTO<MediaDTO>]
        }
    }
    
    
    struct PATCH {
        
        struct Request: Decodable {
            let user: String
            let media: [String]
        }
        
        
        struct Response: Decodable {
            let status: String
            var data: ListDTO<String>
        }
    }
}
