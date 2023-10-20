//
//  ListDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct ListDTO<T>: Decodable where T: Decodable {
    
    let user: String
    let media: [T]
}


extension ListDTO where T == MediaDTO {
    
    func toDomain() -> List<Media> {
        return List(user: user,
                    media: media.map { $0.toDomain() })
    }
}


extension ListDTO where T == String {
    
    func toDomain() -> List<String> {
        return List(user: user,
                    media: media)
    }
}
