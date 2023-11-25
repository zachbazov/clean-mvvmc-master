//
//  Media.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct Media {
    
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
    
    static func ==(lhs: Media, rhs: Media) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Media: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Media {
    
    enum MediaType: String {
        case none = ""
        case series
        case film
    }
    
    enum PresentedLogoAlignment: String {
        case top
        case midTop = "mid-top"
        case mid
        case midBottom = "mid-bottom"
        case bottom
    }
    
    enum PresentedSearchLogoAlignment: String {
        case minXminY, minXmidY, minXmaxY
        case midXminY, midXmidY, midXmaxY
        case maxXminY, maxXmidY, maxXmaxY
    }
    
    enum PresentedPoster: String {
        case first = "0"
        case second = "1"
        case third = "2"
        case fourth = "3"
        case fifth = "4"
        case sixth = "5"
    }
    
    enum PresentedLogo: String {
        case first = "0"
        case second = "1"
        case third = "2"
        case fourth = "3"
        case fifth = "4"
        case sixth = "5"
        case seventh = "6"
    }
    
    enum PresentedDisplayLogo: String {
        case first = "0"
        case second = "1"
        case third = "2"
        case fourth = "3"
        case fifth = "4"
        case sixth = "5"
        case seventh = "6"
    }
    
    enum PresentedSearchLogo: String {
        case first = "0"
        case second = "1"
        case third = "2"
        case fourth = "3"
        case fifth = "4"
        case sixth = "5"
        case seventh = "6"
    }
    
    func path<T>(forResourceOfType type: T.Type) -> String {
        switch type {
        case is PresentedPoster.Type:
            
            switch PresentedPoster(rawValue: resources.presentedPoster) {
            case .first: return resources.posters[0]
            case .second: return resources.posters[1]
            case .third: return resources.posters[2]
            case .fourth: return resources.posters[3]
            case .fifth: return resources.posters[4]
            case .sixth: return resources.posters[5]
            case nil: return ""
            }
            
        case is PresentedLogo.Type:
            
            switch PresentedLogo(rawValue: resources.presentedLogo) {
            case .first: return resources.logos[0]
            case .second: return resources.logos[1]
            case .third: return resources.logos[2]
            case .fourth: return resources.logos[3]
            case .fifth: return resources.logos[4]
            case .sixth: return resources.logos[5]
            case .seventh: return resources.logos[6]
            case nil: return ""
            }
            
        case is PresentedDisplayLogo.Type:
            
            switch PresentedDisplayLogo(rawValue: resources.presentedDisplayLogo) {
            case .first: return resources.logos[0]
            case .second: return resources.logos[1]
            case .third: return resources.logos[2]
            case .fourth: return resources.logos[3]
            case .fifth: return resources.logos[4]
            case .sixth: return resources.logos[5]
            case .seventh: return resources.logos[6]
            case nil: return ""
            }
            
        case is PresentedSearchLogo.Type:
            
            switch PresentedDisplayLogo(rawValue: resources.presentedSearchLogo) {
            case .first: return resources.logos[0]
            case .second: return resources.logos[1]
            case .third: return resources.logos[2]
            case .fourth: return resources.logos[3]
            case .fifth: return resources.logos[4]
            case .sixth: return resources.logos[5]
            case .seventh: return resources.logos[6]
            case nil: return ""
            }
            
        default:
            return ""
        }
    }
}

extension Media {
    
    func separatedAttributedString(separatingBy separator: String, separatorAttributes: NSAttributedString.Attributes, genresAttributes: NSAttributedString.Attributes) -> NSMutableAttributedString {
        
        let mutableString = NSMutableAttributedString()
        
        let mappedGenres = genres.map {
            NSAttributedString(string: $0, attributes: genresAttributes)
        }
        
        mappedGenres.forEach {
            mutableString.append($0)
            
            let attributedSeparator = NSAttributedString(string: separator, attributes: separatorAttributes)
            
            if $0 == mappedGenres.last {
                return
            }
            
            mutableString.append(attributedSeparator)
        }
        
        return mutableString
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
        return map {
            $0.toDTO()
        }
    }
}

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
