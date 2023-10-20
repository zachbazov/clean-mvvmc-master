//
//  HTTPUser.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct HTTPUser: HTTPRepresentable {
    
    struct Request {
        let user: User
        var selectedProfile: String?
    }
    
    struct Response {
        var status: String?
        var token: String?
        var data: User?
    }
}
