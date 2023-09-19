//
//  HTTPProfileDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct HTTPProfileDTO {
    
    struct GET {
        
        struct Request: Decodable {
            let user: UserDTO
            var _id: String?
        }
        
        
        struct Response: Decodable {
            let status: String
            let results: Int
            let data: [ProfileDTO]
        }
    }
    
    
    struct POST {
        
        struct Request: Decodable {
            let user: UserDTO
            let profile: ProfileDTO
        }
        
        
        struct Response: Decodable {
            let status: String
            let data: ProfileDTO
        }
    }
    
    
    struct PATCH {
        
        struct Request: Decodable {
            let user: UserDTO
            var id: String? = nil
            let profile: ProfileDTO
        }
        
        
        struct Response: Decodable {
            let status: String
            let data: ProfileDTO
        }
    }
    
    
    struct DELETE {
        
        struct Request: Decodable {
            let user: UserDTO
            let id: String
        }
        
        
        struct Response: Decodable {
            let status: String
        }
    }
    
    
    struct Settings: Decodable {
        
        struct PATCH {
            
            struct Request: Decodable {
                let user: UserDTO
                let id: String
                let settings: ProfileDTO.Settings
            }
            
            
            struct Response: Decodable {
                let status: String
                let data: ProfileDTO.Settings
            }
        }
    }
}
