//
//  ProfileDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

@objc
public final class ProfileDTO: NSObject, Codable, NSSecureCoding {
    
    @objc(Settings)
    public final class Settings: NSObject, Codable, NSSecureCoding {
        
        var _id: String?
        var maturityRating: String
        var displayLanguage: String
        var audioAndSubtitles: String
        var autoplayNextEpisode: Bool
        var autoplayPreviews: Bool
        
        public static var supportsSecureCoding: Bool {
            return true
        }
        
        
        init(_id: String?,
             maturityRating: String,
             displayLanguage: String,
             audioAndSubtitles: String,
             autoplayNextEpisode: Bool,
             autoplayPreviews: Bool) {
            self._id = _id
            self.maturityRating = maturityRating
            self.displayLanguage = displayLanguage
            self.audioAndSubtitles = audioAndSubtitles
            self.autoplayNextEpisode = autoplayNextEpisode
            self.autoplayPreviews = autoplayPreviews
        }
        
        public required init?(coder: NSCoder) {
            
            self._id = coder.decodeObject(
                of: [ProfileDTO.self, NSString.self],
                forKey: "_id") as? String ?? ""
            
            self.maturityRating = coder.decodeObject(
                of: [ProfileDTO.self, NSString.self],
                forKey: "maturityRating") as? String ?? ""
            
            self.displayLanguage = coder.decodeObject(
                of: [ProfileDTO.self, NSString.self],
                forKey: "displayLanguage") as? String ?? ""
            
            self.audioAndSubtitles = coder.decodeObject(
                of: [ProfileDTO.self, NSString.self],
                forKey: "audioAndSubtitles") as? String ?? ""
            
            self.autoplayNextEpisode = coder.decodeBool(forKey: "autoplayNextEpisode")
            
            self.autoplayPreviews = coder.decodeBool(forKey: "autoplayPreviews")
        }
        
        public func encode(with coder: NSCoder) {
            coder.encode(_id, forKey: "_id")
            coder.encode(maturityRating, forKey: "maturityRating")
            coder.encode(displayLanguage, forKey: "displayLanguage")
            coder.encode(audioAndSubtitles, forKey: "audioAndSubtitles")
            coder.encode(autoplayNextEpisode, forKey: "autoplayNextEpisode")
            coder.encode(autoplayPreviews, forKey: "autoplayPreviews")
        }
    }
    
    
    var _id: String?
    let name: String
    let image: String
    let active: Bool
    let user: String
    var settings: Settings?
    
    
    init(_id: String? = nil,
         name: String,
         image: String,
         active: Bool,
         user: String,
         settings: Settings?) {
        self._id = _id
        self.name = name
        self.image = image
        self.active = active
        self.user = user
        self.settings = settings
    }
    
    public required init?(coder: NSCoder) {
        self._id = coder.decodeObject(of: [ProfileDTO.self, NSString.self], forKey: "_id") as? String ?? ""
        self.name = coder.decodeObject(of: [ProfileDTO.self, NSString.self], forKey: "name") as? String ?? ""
        self.image = coder.decodeObject(of: [ProfileDTO.self, NSString.self], forKey: "image") as? String ?? ""
        self.active = coder.decodeBool(forKey: "active")
        self.user = coder.decodeObject(of: [ProfileDTO.self, NSString.self], forKey: "user") as? String ?? ""
        self.settings = coder.decodeObject(of: [ProfileDTO.self, Settings.self], forKey: "settings") as? Settings ?? .defaultValue
    }
}


extension ProfileDTO {
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(_id, forKey: "_id")
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
        coder.encode(active, forKey: "active")
        coder.encode(user, forKey: "user")
        coder.encode(settings, forKey: "settings")
    }
}


extension ProfileDTO {
    
    func toDomain() -> Profile {
        
        guard let id = _id else {
            
            return Profile(name: name,
                           image: image,
                           active: active,
                           user: user,
                           settings: settings?.toDomain() ?? .defaultValue)
        }
        
        return Profile(_id: id,
                       name: name,
                       image: image,
                       active: active,
                       user: user,
                       settings: settings?.toDomain() ?? .defaultValue)
    }
}


extension Array where Element == ProfileDTO {
    
    func toDomain() -> [Profile] {
        return map { $0.toDomain() }
    }
}


extension ProfileDTO.Settings {
    
    func toDomain() -> Profile.Settings {
        return Profile.Settings(_id: _id,
                                maturityRating: MaturityRating(rawValue: maturityRating) ?? .none,
                                displayLanguage: displayLanguage,
                                audioAndSubtitles: audioAndSubtitles,
                                autoplayNextEpisode: autoplayNextEpisode,
                                autoplayPreviews: autoplayPreviews)
    }
}


extension ProfileDTO.Settings {
    
    static var defaultValue: ProfileDTO.Settings {
        return ProfileDTO.Settings(
            _id: "",
            maturityRating: "none",
            displayLanguage: "en",
            audioAndSubtitles: "en",
            autoplayNextEpisode: true,
            autoplayPreviews: true)
    }
}
