//
//  MediaCollectionViewCellViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/11/2023.
//

import Foundation

struct MediaCollectionViewCellViewModel {
    
    let title: String
    let slug: String
    let posters: [String]
    let logos: [String]
    var posterImagePath: String!
    var posterImageIdentifier: NSString
    var posterImageURL: URL!
    var logoImagePath: String!
    var logoImageIdentifier: NSString
    var logoImageURL: URL!
    let presentedLogoAlignment: Media.PresentedLogoAlignment
    
    init(media: Media) {
        self.title = media.title
        self.slug = media.slug
        self.posters = media.resources.posters
        self.logos = media.resources.logos
        
        self.presentedLogoAlignment = Media.PresentedLogoAlignment(rawValue: media.resources.presentedLogoAlignment)!
        
        self.posterImageIdentifier = NSString(string: "poster_\(media.slug)")
        self.logoImageIdentifier = NSString(string: "logo_\(media.slug)")
        
        self.posterImagePath = media.path(forResourceOfType: Media.PresentedPoster.self)
        self.logoImagePath = media.path(forResourceOfType: Media.PresentedLogo.self)
        
        let host = Application.app.server.hostProvider.absoluteString
        let posterImageUrlPath = host + self.posterImagePath
        let logoImageUrlPath = host + self.logoImagePath
        
        self.posterImageURL = URL(string: posterImageUrlPath)
        self.logoImageURL = URL(string: logoImageUrlPath)
    }
    
    func loadImages() {
        let imageService = Application.app.server.imageService
        print("loadImages vm", title)
        imageService.load(url: posterImageURL, identifier: posterImageIdentifier) { _ in
        }
        
        imageService.load(url: logoImageURL, identifier: logoImageIdentifier) { _ in
        }
    }
}
