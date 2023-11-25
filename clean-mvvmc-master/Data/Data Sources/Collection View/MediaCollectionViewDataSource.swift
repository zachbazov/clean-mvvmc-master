//
//  MediaCollectionViewDataSource.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

final class MediaCollectionViewDataSource<Cell>: NSObject,
                                                 UICollectionViewDelegate,
                                                 UICollectionViewDataSource,
                                                 UICollectionViewDataSourcePrefetching where Cell: UICollectionViewCell {
    
    private weak var collectionView: UICollectionView?
    
    private let viewModel: HomeViewModel
    
    private let section: Section
    
    init(_ collectionView: UICollectionView, section: Section, with viewModel: HomeViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        self.section = section
    }
    
    func dataSourceDidChange() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.prefetchDataSource = self
        collectionView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = MediaTableViewDataSource.Section(rawValue: section.id) else {
            fatalError()
        }
        
        switch section {
        case .rated:
            let cell: RatingCollectionViewCell = RatingCollectionViewCell.create(in: collectionView,
                                                   for: indexPath,
                                                   section: self.section,
                                                   with: viewModel)
            return cell
        case .resumable:
            let cell: ResumingCollectionViewCell = ResumingCollectionViewCell.create(in: collectionView,
                                                     for: indexPath,
                                                     section: self.section,
                                                     with: viewModel)
            return cell
        case .blockbuster:
            let cell: BrandCollectionViewCell = BrandCollectionViewCell.create(in: collectionView,
                                                  for: indexPath,
                                                  section: self.section,
                                                  with: viewModel)
            return cell
        default:
            let cell: PosterCollectionViewCell = PosterCollectionViewCell.create(in: collectionView,
                                                   for: indexPath,
                                                   section: self.section,
                                                   with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.opacityAnimation()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let imageService = Application.app.server.imageService
            let host = Application.app.server.hostProvider.absoluteString
            let media = self.section.media[indexPath.row]
            let posterImagePath = media.path(forResourceOfType: Media.PresentedPoster.self)
            let logoImagePath = media.path(forResourceOfType: Media.PresentedLogo.self)
            let posterImageURL = URL(string: host + posterImagePath)!
            let logoImageURL = URL(string: host + logoImagePath)!
            let posterImageIdentifier = "poster_\(media.slug)" as NSString
            let logoImageIdentifier = "logo_\(media.slug)" as NSString
            
            imageService.load(url: posterImageURL, identifier: posterImageIdentifier) { _ in
            }
            
            imageService.load(url: logoImageURL, identifier: logoImageIdentifier) { _ in
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    }
}
