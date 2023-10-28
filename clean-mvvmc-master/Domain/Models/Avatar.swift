//
//  Avatar.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/10/2023.
//

import Foundation

struct Avatar {
    var image: String
}


extension Array where Element == String {
    
    func toDomain() -> [Avatar] {
        return map { Avatar(image: $0) }
    }
}


extension String {
    
    func toAvatar() -> Avatar {
        return Avatar(image: self)
    }
}
