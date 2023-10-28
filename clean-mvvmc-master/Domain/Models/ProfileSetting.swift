//
//  ProfileSetting.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

// MARK: - ProfileSetting Type

struct ProfileSetting {
    
    let image: String
    let title: String
    var subtitle: String? = nil
    let hasSubtitle: Bool
    let isSwitchable: Bool
}


extension ProfileSetting {
    
    static var maturityRating: ProfileSetting {
        return ProfileSetting(image: "exclamationmark.octagon",
                              title: "Maturiy Rating",
                              subtitle: "No restrictions",
                              hasSubtitle: true,
                              isSwitchable: false)
    }
    
    static var displayLanguageSetting: ProfileSetting {
        return ProfileSetting(image: "textformat",
                              title: "Display Language",
                              subtitle: "English",
                              hasSubtitle: true,
                              isSwitchable: false)
    }
    
    static var audioAndSubtitlesSetting: ProfileSetting {
        return ProfileSetting(image: "text.bubble.fill",
                              title: "Audio & Subtitles",
                              subtitle: "English",
                              hasSubtitle: true,
                              isSwitchable: false)
    }
    
    static var autoplayNextEpisodeSetting: ProfileSetting {
        return ProfileSetting(image: "arrow.right.square",
                              title: "Autoplay Next Episode",
                              hasSubtitle: false,
                              isSwitchable: true)
    }
    
    static var autoplayPreviewsSetting: ProfileSetting {
        return ProfileSetting(image: "autostartstop",
                              title: "Autoplay Previews",
                              hasSubtitle: false,
                              isSwitchable: true)
    }
}
