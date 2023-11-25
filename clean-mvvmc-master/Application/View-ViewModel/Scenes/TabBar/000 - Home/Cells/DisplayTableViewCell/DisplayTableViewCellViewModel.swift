//
//  DisplayTableViewCellViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 24/11/2023.
//

import Foundation

struct DisplayTableViewCellViewModel {
    
    let slug: String
    let genres: [String]
    let posterImagePath: String
    let posterImageIdentifier: NSString
    var posterImageURL: URL!
    var logoImagePath: String
    let logoImageIdentifier: NSString
    var logoImageURL: URL!
    let attributedGenres: NSMutableAttributedString
    var typeImagePath: String?
    
    init(with media: Media) {
        self.slug = media.slug
        self.genres = media.genres
        
        self.posterImageIdentifier = NSString(string: "poster_\(media.slug)")
        self.logoImageIdentifier = NSString(string: "display-logo_\(media.slug)")
        
        self.posterImagePath = media.path(forResourceOfType: Media.PresentedPoster.self)
        self.logoImagePath = media.path(forResourceOfType: Media.PresentedDisplayLogo.self)
        
        self.attributedGenres = media.separatedAttributedString(separatingBy: " · ", separatorAttributes: NSAttributedString.displayGenresSeparatorAttributes, genresAttributes: NSAttributedString.displayGenresAttributes)
        
        let host = Application.app.server.hostProvider.absoluteString
        let posterImageUrlPath = host + self.posterImagePath
        let logoImageUrlPath = host + self.logoImagePath
        
        self.posterImageURL = URL(string: posterImageUrlPath)!
        self.logoImageURL = URL(string: logoImageUrlPath)!
        
        self.typeImagePath = self.setMediaTypeImage(for: media)
        
    }
    
    private mutating func setMediaTypeImage(for media: Media) -> String? {
        guard let type = Media.MediaType(rawValue: media.type) else {
            return nil
        }
        
        switch type {
        case .series where media.isExclusive:
            return "netflix-series"
        case .film where media.isExclusive:
            return "netflix-film"
        default:
            return nil
        }
    }
}
