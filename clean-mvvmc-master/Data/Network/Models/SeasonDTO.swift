//
//  SeasonDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct SeasonDTO: Decodable {
    let mediaId: String
    let title: String
    let slug: String
    let season: Int
    var episodes: [EpisodeDTO]
}


extension SeasonDTO {
    
    func toDomain() -> Season {
        return Season(mediaId: mediaId,
                      title: title,
                      slug: slug,
                      season: season,
                      episodes: episodes.map { $0.toDomain() })
    }
}
