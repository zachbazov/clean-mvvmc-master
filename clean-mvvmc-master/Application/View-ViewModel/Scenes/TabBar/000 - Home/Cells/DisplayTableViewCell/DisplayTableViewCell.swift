//
//  DisplayTableViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/11/2023.
//

import UIKit

final class DisplayTableViewCell: UITableViewCell, TableViewCell {
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var genresLabel: UILabel!
    
    var viewModel: DisplayTableViewCellViewModel!
    
    deinit {
        deallocateSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func deploySubviews() {
        loadImages()
        configureSubviews()
    }
    
    func configureSubviews() {
        setImages()
        setPosterStroke()
        setGenres(attributed: viewModel.attributedGenres)
        setMediaType()
    }
    
    func deallocateSubviews() {
        
    }
    
    func cellDidTap() {
    }
    
    func cellDidLongPress(_ gesture: UILongPressGestureRecognizer) {
    }
    
    private func loadImages() {
        let imageService = Application.app.server.imageService
        
        imageService.load(url: viewModel.posterImageURL, identifier: viewModel.posterImageIdentifier) { [weak self] image in
            guard let self = self else {
                return
            }
            
            self.posterImageView.image = image
        }
        
        imageService.load(url: viewModel.logoImageURL, identifier: viewModel.logoImageIdentifier) { [weak self] image in
            guard let self = self else {
                return
            }
            
            self.logoImageView.image = image
        }
    }
    
    private func setImages() {
        let imageService = Application.app.server.imageService
        
        guard let posterImage = imageService.cache.object(forKey: viewModel.posterImageIdentifier),
              let logoImage = imageService.cache.object(forKey: viewModel.logoImageIdentifier) else {
            return
        }
        
        posterImageView.image = posterImage
        logoImageView.image = logoImage
    }
    
    private func setPosterStroke() {
        let gradient = UIImage.fillGradientStroke(bounds: posterImageView.bounds,
                                                  colors: [.white.withAlphaComponent(0.5),
                                                           UIColor.white.withAlphaComponent(0.15),
                                                           .clear])
        
        let color = UIColor(patternImage: gradient).cgColor
        
        posterImageView?.layer.borderColor = color
        posterImageView?.layer.borderWidth = 2.0
        posterImageView?.layer.cornerRadius = 12.0
    }
    
    private func setGenres(attributed string: NSMutableAttributedString) {
        genresLabel.attributedText = string
    }
    
    private func setMediaType() {
        guard let typeImagePath = viewModel.typeImagePath else {
            return
        }
        
        typeImageView.image = UIImage(named: typeImagePath)
    }
}
