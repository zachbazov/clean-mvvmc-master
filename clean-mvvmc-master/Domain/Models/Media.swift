//
//  Media.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

protocol MediaRepresentable {
    var id: String? { get }
    var title: String { get }
    var slug: String { get }
}


struct Media: MediaRepresentable {
    
    struct Resources {
        let posters: [String]
        let logos: [String]
        let trailers: [String]
        let displayPoster: String
        let previewPoster: String
        let previewUrl: String
        let presentedPoster: String
        let presentedLogo: String
        let presentedDisplayLogo: String
        let presentedLogoAlignment: String
        let presentedSearchLogo: String
        let presentedSearchLogoAlignment: String
    }
    
    
    var id: String?
    let type: String
    let title: String
    let slug: String
    let createdAt: String
    let rating: Float
    let description: String
    let cast: String
    let writers: String
    let duration: String
    let length: String
    let genres: [String]
    let hasWatched: Bool
    let isHD: Bool
    let isExclusive: Bool
    let isNewRelease: Bool
    let isSecret: Bool
    let resources: Resources
    var seasons: [String]?
    let timesSearched: Int
}


extension Media: Equatable {
    
    static func ==(lhs: Media, rhs: Media) -> Bool { lhs.id == rhs.id }
}


extension Media: Hashable {
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}


extension Media {
    
    enum MediaType: String {
        case none = ""
        case series
        case film
    }
}


extension Media {
    
    func toDTO() -> MediaDTO {
        return MediaDTO(
            id: id,
            type: type,
            title: title,
            slug: slug,
            createdAt: createdAt,
            rating: rating,
            description: description,
            cast: cast,
            writers: writers,
            duration: duration,
            length: length,
            genres: genres,
            hasWatched: hasWatched,
            isHD: isHD,
            isExclusive: isExclusive,
            isNewRelease: isNewRelease,
            isSecret: isSecret,
            resources: resources.toDTO(),
            seasons: seasons,
            timesSearched: timesSearched)
    }
}

extension Media.Resources {
    
    func toDTO() -> MediaDTO.Resources {
        return MediaDTO.Resources(
            posters: posters,
            logos: logos,
            trailers: trailers,
            displayPoster: displayPoster,
            previewPoster: previewPoster,
            previewUrl: previewUrl,
            presentedPoster: presentedPoster,
            presentedLogo: presentedLogo,
            presentedDisplayLogo: presentedDisplayLogo,
            presentedLogoAlignment: presentedLogoAlignment,
            presentedSearchLogo: presentedSearchLogo,
            presentedSearchLogoAlignment: presentedSearchLogoAlignment)
    }
}

extension Array where Element == Media {
    
    func toDTO() -> [MediaDTO] {
        return map { $0.toDTO() }
    }
}

// MARK: - Vacant Value

extension Media {
    static var vacantValue: Media {
        let resources = Media.Resources(
            posters: [],
            logos: [],
            trailers: [],
            displayPoster: "",
            previewPoster: "",
            previewUrl: "",
            presentedPoster: "",
            presentedLogo: "",
            presentedDisplayLogo: "",
            presentedLogoAlignment: "",
            presentedSearchLogo: "",
            presentedSearchLogoAlignment: "")
        
        return Media(
            id: "",
            type: "",
            title: "",
            slug: "",
            createdAt: "",
            rating: .zero,
            description: "",
            cast: "",
            writers: "",
            duration: "",
            length: "",
            genres: [],
            hasWatched: false,
            isHD: false,
            isExclusive: false,
            isNewRelease: false,
            isSecret: false,
            resources: resources,
            seasons: [],
            timesSearched: .zero)
    }
}
