//
//  MediaDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import CoreData

// MARK: - MediaDTO Type

@objc
public final class MediaDTO: NSObject, Codable, NSSecureCoding {
    
    @objc(Resources)
    public final class Resources: NSObject, Codable, NSSecureCoding {
        
        let posters: [String]
        let logos: [String]
        let trailers: [String]
        let displayPoster: String
        let previewPoster: String
        let previewUrl: String?
        let presentedPoster: String
        let presentedLogo: String
        let presentedDisplayLogo: String
        let presentedLogoAlignment: String
        let presentedSearchLogo: String
        let presentedSearchLogoAlignment: String
        
        init(posters: [String],
             logos: [String],
             trailers: [String],
             displayPoster: String,
             previewPoster: String,
             previewUrl: String,
             presentedPoster: String,
             presentedLogo: String,
             presentedDisplayLogo: String,
             presentedLogoAlignment: String,
             presentedSearchLogo: String,
             presentedSearchLogoAlignment: String) {
            self.posters = posters
            self.logos = logos
            self.trailers = trailers
            self.displayPoster = displayPoster
            self.previewPoster = previewPoster
            self.previewUrl = previewUrl
            self.presentedPoster = presentedPoster
            self.presentedLogo = presentedLogo
            self.presentedDisplayLogo = presentedDisplayLogo
            self.presentedLogoAlignment = presentedLogoAlignment
            self.presentedSearchLogo = presentedSearchLogo
            self.presentedSearchLogoAlignment = presentedSearchLogoAlignment
        }
        
        public init?(coder: NSCoder) {
            self.posters = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: "posters") as? [String] ?? []
            self.logos = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: "logos") as? [String] ?? []
            self.trailers = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: "trailers") as? [String] ?? []
            self.displayPoster = coder.decodeObject(of: NSString.self, forKey: "displayPoster") as? String ?? ""
            self.previewPoster = coder.decodeObject(of: NSString.self, forKey: "previewPoster") as? String ?? ""
            self.previewUrl = coder.decodeObject(of: NSString.self, forKey: "previewUrl") as? String ?? ""
            self.presentedPoster = coder.decodeObject(of: NSString.self, forKey: "presentedPoster") as? String ?? ""
            self.presentedLogo = coder.decodeObject(of: NSString.self, forKey: "presentedLogo") as? String ?? ""
            self.presentedDisplayLogo = coder.decodeObject(of: NSString.self, forKey: "presentedDisplayLogo") as? String ?? ""
            self.presentedLogoAlignment = coder.decodeObject(of: NSString.self, forKey: "presentedLogoAlignment") as? String ?? ""
            self.presentedSearchLogo = coder.decodeObject(of: NSString.self, forKey: "presentedSearchLogo") as? String ?? ""
            self.presentedSearchLogoAlignment = coder.decodeObject(of: NSString.self, forKey: "presentedSearchLogoAlignment") as? String ?? ""
        }
        
        
        public static var supportsSecureCoding: Bool { true }
        
        
        public func encode(with coder: NSCoder) {
            coder.encode(posters, forKey: "posters")
            coder.encode(logos, forKey: "logos")
            coder.encode(trailers, forKey: "trailers")
            coder.encode(displayPoster, forKey: "displayPoster")
            coder.encode(previewPoster, forKey: "previewPoster")
            coder.encode(previewUrl, forKey: "previewUrl")
            coder.encode(presentedPoster, forKey: "presentedPoster")
            coder.encode(presentedLogo, forKey: "presentedLogo")
            coder.encode(presentedDisplayLogo, forKey: "presentedDisplayLogo")
            coder.encode(presentedLogoAlignment, forKey: "presentedLogoAlignment")
            coder.encode(presentedSearchLogo, forKey: "presentedSearchLogo")
            coder.encode(presentedSearchLogoAlignment, forKey: "presentedSearchLogoAlignment")
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case slug
        case createdAt
        case rating
        case _description = "description"
        case cast
        case writers
        case duration
        case length
        case genres
        case hasWatched
        case isHD
        case isExclusive
        case isNewRelease
        case isSecret
        case resources
        case seasons
        case timesSearched
    }
    
    
    let id: String?
    let type: String
    let title: String
    let slug: String
    let createdAt: String
    let rating: Float
    let _description: String
    let cast: String
    let writers: String?
    let duration: String?
    let length: String
    let genres: [String]
    let hasWatched: Bool
    let isHD: Bool
    let isExclusive: Bool
    let isNewRelease: Bool
    let isSecret: Bool
    let resources: MediaDTO.Resources
    let seasons: [String]?
    let timesSearched: Int
    
    init(id: String?,
         type: String,
         title: String,
         slug: String,
         createdAt: String,
         rating: Float,
         description: String,
         cast: String,
         writers: String?,
         duration: String?,
         length: String,
         genres: [String],
         hasWatched: Bool,
         isHD: Bool,
         isExclusive: Bool,
         isNewRelease: Bool,
         isSecret: Bool,
         resources: MediaDTO.Resources,
         seasons: [String]?,
         timesSearched: Int) {
        self.id = id
        self.type = type
        self.title = title
        self.slug = slug
        self.createdAt = createdAt
        self.rating = rating
        self._description = description
        self.cast = cast
        self.writers = writers
        self.duration = duration
        self.length = length
        self.genres = genres
        self.hasWatched = hasWatched
        self.isHD = isHD
        self.isExclusive = isExclusive
        self.isNewRelease = isNewRelease
        self.isSecret = isSecret
        self.resources = resources
        self.seasons = seasons
        self.timesSearched = timesSearched
    }
    
    public init?(coder: NSCoder) {
        self.id = coder.decodeObject(of: NSString.self, forKey: "id") as? String ?? ""
        self.type = coder.decodeObject(of: NSString.self, forKey: "type") as? String ?? ""
        self.title = coder.decodeObject(of: NSString.self, forKey: "title") as? String ?? ""
        self.slug = coder.decodeObject(of: NSString.self, forKey: "slug") as? String ?? ""
        self.createdAt = coder.decodeObject(of: NSString.self, forKey: "createdAt") as? String ?? ""
        self.rating = coder.decodeFloat(forKey: "rating")
        self._description = coder.decodeObject(of: NSString.self, forKey: "desc") as? String ?? ""
        self.cast = coder.decodeObject(of: NSString.self, forKey: "cast") as? String ?? ""
        self.writers = coder.decodeObject(of: NSString.self, forKey: "writers") as? String ?? ""
        self.duration = coder.decodeObject(of: NSString.self, forKey: "duration") as? String ?? ""
        self.length = coder.decodeObject(of: NSString.self, forKey: "length") as? String ?? ""
        self.genres = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: "genres") as? [String] ?? []
        self.hasWatched = coder.decodeBool(forKey: "hasWatched")
        self.isHD = coder.decodeBool(forKey: "isHD")
        self.isExclusive = coder.decodeBool(forKey: "isExclusive")
        self.isNewRelease = coder.decodeBool(forKey: "isNewRelease")
        self.isSecret = coder.decodeBool(forKey: "isSecret")
        self.resources = coder.decodeObject(of: [MediaDTO.self, MediaDTO.Resources.self], forKey: "resources") as! MediaDTO.Resources
        self.seasons = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: "seasons") as? [String] ?? []
        self.timesSearched = coder.decodeInteger(forKey: "timesSearched")
    }
    
    
    public static var supportsSecureCoding: Bool { true }

    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(type, forKey: "type")
        coder.encode(title, forKey: "title")
        coder.encode(slug, forKey: "slug")
        coder.encode(createdAt, forKey: "createdAt")
        coder.encode(rating, forKey: "rating")
        coder.encode(_description, forKey: "desc")
        coder.encode(cast, forKey: "cast")
        coder.encode(writers, forKey: "writers")
        coder.encode(duration, forKey: "duration")
        coder.encode(length, forKey: "length")
        coder.encode(genres, forKey: "genres")
        coder.encode(hasWatched, forKey: "hasWatched")
        coder.encode(isHD, forKey: "isHD")
        coder.encode(isExclusive, forKey: "isExclusive")
        coder.encode(isNewRelease, forKey: "isNewRelease")
        coder.encode(isSecret, forKey: "isSecret")
        coder.encode(resources, forKey: "resources")
        coder.encode(seasons, forKey: "seasons")
        coder.encode(timesSearched, forKey: "timesSearched")
    }
}


extension MediaDTO.Resources {
    
    func toDomain() -> Media.Resources {
        return Media.Resources(
            posters: posters,
            logos: logos,
            trailers: trailers,
            displayPoster: displayPoster,
            previewPoster: previewPoster,
            previewUrl: previewUrl ?? "",
            presentedPoster: presentedPoster,
            presentedLogo: presentedLogo,
            presentedDisplayLogo: presentedDisplayLogo,
            presentedLogoAlignment: presentedLogoAlignment,
            presentedSearchLogo: presentedSearchLogo,
            presentedSearchLogoAlignment: presentedSearchLogoAlignment)
    }
}


extension MediaDTO {
    
    func toDomain() -> Media {
        return Media(id: id,
                     type: type,
                     title: title,
                     slug: slug,
                     createdAt: createdAt,
                     rating: rating,
                     description: _description,
                     cast: cast,
                     writers: writers ?? "",
                     duration: duration ?? "",
                     length: length,
                     genres: genres,
                     hasWatched: hasWatched,
                     isHD: isHD,
                     isExclusive: isExclusive,
                     isNewRelease: isNewRelease,
                     isSecret: isSecret,
                     resources: resources.toDomain(),
                     seasons: seasons,
                     timesSearched: timesSearched)
    }
}


extension Array where Element == MediaDTO {
    
    func toDomain() -> [Media] {
        return map { $0.toDomain() }
    }
}
