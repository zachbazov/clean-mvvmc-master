//
//  HTTPProfile.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct HTTPProfile {
    
    struct GET: HTTPRepresentable {
        
        struct Request {
            let user: User
        }
        
        struct Response {
            let status: String
            let results: Int
            let data: [Profile]
        }
    }
    
    struct POST: HTTPRepresentable {
        
        struct Request {
            let user: User
            let profile: Profile
        }
        
        struct Response {
            let status: String
            let data: Profile
        }
    }
    
    struct PATCH: HTTPRepresentable {
        
        struct Request {
            let user: User
        }
        
        struct Response {
            let status: String
            let data: Profile
        }
    }
    
    struct DELETE: HTTPRepresentable {
        
        struct Request {
            let user: User
            let id: String
        }
        
        struct Response {
            let status: String
        }
    }
}
