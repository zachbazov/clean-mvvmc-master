//
//  HTTPSeasonDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct HTTPSeasonDTO {
    
    struct Request: Decodable {
        var id: String?
        var slug: String?
        var season: Int?
    }
    
    
    struct Response: Decodable {
        let status: String
        let data: [SeasonDTO]
    }
}
