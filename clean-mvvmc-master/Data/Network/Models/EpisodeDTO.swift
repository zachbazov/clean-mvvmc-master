//
//  EpisodeDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct EpisodeDTO: Decodable {
    let mediaId: String
    let title: String
    let slug: String
    let season: Int
    let episode: Int
    let url: String
}


extension EpisodeDTO {
    
    func toDomain() -> Episode {
        return Episode(mediaId: mediaId,
                       title: title,
                       slug: slug,
                       season: season,
                       episode: episode,
                       url: url)
    }
}
