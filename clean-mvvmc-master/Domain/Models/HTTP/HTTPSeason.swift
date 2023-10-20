//
//  HTTPSeason.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/10/2023.
//

import Foundation

struct HTTPSeason: HTTPRepresentable {
    
    struct Request {
        var id: String?
        var slug: String?
        var season: Int?
    }
    
    struct Response {
        let status: String
        var data: Season?
    }
}
