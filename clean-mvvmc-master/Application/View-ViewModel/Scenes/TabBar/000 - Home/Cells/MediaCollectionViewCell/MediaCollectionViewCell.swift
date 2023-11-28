//
//  MediaCollectionViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/11/2023.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var logoBottomConstraint: NSLayoutConstraint!
    
    var viewModel: MediaCollectionViewCellViewModel!
    
    var indexPath: IndexPath!
    
    func deploySubviews() {
        loadImages()
    }
    
    func loadImages() {
        let group = DispatchGroup()
        let imageService = Application.app.server.imageService
        
        group.enter()
        
        imageService.load(url: viewModel.posterImageURL, identifier: viewModel.posterImageIdentifier) { _ in
            group.leave()
        }
        
        group.enter()
        
        imageService.load(url: viewModel.logoImageURL, identifier: viewModel.logoImageIdentifier) { _ in
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.setImages()
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
}
