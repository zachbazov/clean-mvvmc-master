//
//  Trailer.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct Trailer {
    
    var id: String?
    var title: String = ""
    var slug: String = ""
    let urlPath: String
}


extension Array where Element == String {
    
    func toDomain() -> [Trailer] {
        return map { Trailer(urlPath: $0) }
    }
}
