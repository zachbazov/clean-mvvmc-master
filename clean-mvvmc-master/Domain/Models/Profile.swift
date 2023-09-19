//
//  Profile.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import Foundation

enum MaturityRating: String, Codable {
    case none = "none"
    case pg13 = "pg-13"
    case r5 = "r-5"
}


enum DisplayLanguage: String, Codable {
    case english = "en"
}


enum AudioSubtitles: String, Codable {
    case english = "en"
}


struct Profile {
    
    struct Settings {
        let _id: String
        var maturityRating: MaturityRating
        var displayLanguage: DisplayLanguage
        var audioAndSubtitles: AudioSubtitles
        var autoplayNextEpisode: Bool
        var autoplayPreviews: Bool
        let profile: String
    }
    
    
    var _id: String?
    var name: String
    var image: String
    var active: Bool?
    var user: String?
    var settings: Settings?
}


extension Profile: Equatable {
    
    static func ==(lhs: Profile, rhs: Profile) -> Bool {
        return lhs._id == rhs._id &&
            lhs.name == rhs.name &&
            lhs.image == rhs.image &&
            lhs.settings == rhs.settings
    }
}


extension Profile.Settings: Equatable {
    
    static func ==(lhs: Profile.Settings, rhs: Profile.Settings) -> Bool {
        return lhs.maturityRating == rhs.maturityRating &&
            lhs.displayLanguage == rhs.displayLanguage &&
            lhs.audioAndSubtitles == rhs.audioAndSubtitles &&
            lhs.autoplayNextEpisode == rhs.autoplayNextEpisode &&
            lhs.autoplayPreviews == rhs.autoplayPreviews
    }
}


extension Profile.Settings {
    
    static var defaultValue: Profile.Settings {
        return Profile.Settings(
            _id: "",
            maturityRating: .none,
            displayLanguage: .english,
            audioAndSubtitles: .english,
            autoplayNextEpisode: true,
            autoplayPreviews: true,
            profile: "")
    }
}


extension Profile {
    func toDTO() -> ProfileDTO {
        return ProfileDTO(
            _id: _id,
            name: name,
            image: image,
            active: active ?? false,
            user: user ?? "",
            settings: settings?.toDTO() ?? .defaultValue)
    }
}


extension Array where Element == Profile {
    
    func toDTO() -> [ProfileDTO] {
        return map { $0.toDTO() }
    }
}

extension Profile.Settings {
    
    func toDTO() -> ProfileDTO.Settings {
        return ProfileDTO.Settings(
            _id: _id,
            maturityRating: maturityRating,
            displayLanguage: displayLanguage,
            audioAndSubtitles: audioAndSubtitles,
            autoplayNextEpisode: autoplayNextEpisode,
            autoplayPreviews: autoplayPreviews,
            profile: profile)
    }
}
