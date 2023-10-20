//
//  HTTPMedia.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct HTTPMedia: HTTPRepresentable {
    
    struct Request {
        var user: User?
        //let media:
    }
    
    struct Response {
        let status: String
        let results: Int
        let data: [Media]
    }
}
