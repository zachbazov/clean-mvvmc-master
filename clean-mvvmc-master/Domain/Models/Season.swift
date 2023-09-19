//
//  Season.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct Season {
    let mediaId: String
    let title: String
    let slug: String
    let season: Int
    let episodes: [Episode]
}


extension Season {
    
    static var vacantValue: Season {
        return Season(mediaId: "",
                      title: "",
                      slug: "",
                      season: .zero,
                      episodes: [])
    }
}
