//
//  HTTPSection.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct HTTPSection: HTTPRepresentable {
    
    struct Request {
        let user: User
    }
    
    struct Response {
        let status: String
        let results: Int
        let data: [Section]
    }
}
