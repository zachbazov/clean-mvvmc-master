//
//  HTTPList.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct HTTPList {
    
    struct GET: HTTPRepresentable {
        
        struct Request {
            let user: User
        }
        
        struct Response {
            let status: String
            let data: List<Media>
        }
    }
    
    struct PATCH: HTTPRepresentable {
        
        struct Request {
            let user: String
            let media: [String]
        }
        
        struct Response {
            let status: String
            let data: List<String>
        }
    }
}
