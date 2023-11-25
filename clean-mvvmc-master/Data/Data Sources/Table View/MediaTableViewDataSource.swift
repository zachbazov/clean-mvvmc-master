//
//  MediaTableViewDataSource.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

final class MediaTableViewDataSource: NSObject,
                                      UITableViewDelegate,
                                      UITableViewDataSource,
                                      UITableViewDataSourcePrefetching {
    
    private weak var tableView: UITableView?
    
    private var viewModel: HomeViewModel
    
    private var displayCell: DisplayTableViewCell!
    
    init(_ tableView: UITableView, with viewModel: HomeViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
    }
    
    func dataSourceDidChange() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.prefetchDataSource = self
        tableView?.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        
        switch section {
        case .display:
            guard !viewModel.media.isEmpty else {
                return SkeletonDisplayTableViewCell.create(in: tableView, for: indexPath, typeOf: SkeletonDisplayTableViewCell.self, with: viewModel)
            }
            
            displayCell = DisplayTableViewCell.create(in: tableView, for: indexPath, typeOf: DisplayTableViewCell.self, with: viewModel)
            return displayCell
            
        case .rated:
            return MediaHybridCell<RatingCollectionViewCell>.create(in: tableView, for: indexPath, embeddingWith: MediaHybridCell<RatingCollectionViewCell>.self, with: viewModel)
            
        case .resumable:
            return MediaHybridCell<ResumingCollectionViewCell>.create(in: tableView, for: indexPath, embeddingWith: MediaHybridCell<ResumingCollectionViewCell>.self, with: viewModel)
            
        case .blockbuster:
            return MediaHybridCell<BrandCollectionViewCell>.create(in: tableView, for: indexPath, embeddingWith: MediaHybridCell<BrandCollectionViewCell>.self, with: viewModel)
            
        default:
            return MediaHybridCell<PosterCollectionViewCell>.create(in: tableView, for: indexPath, embeddingWith: MediaHybridCell<PosterCollectionViewCell>.self, with: viewModel)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.opacityAnimation()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let section = Section(rawValue: indexPath.section) else {
            return .zero
        }
        
        switch section {
        case .display:
            return tableView.bounds.height * 0.75
            
        case .blockbuster:
            return tableView.bounds.height * 0.415
            
        default:
            return tableView.bounds.height * 0.215
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else {
            return UITableView.UISpacerView()
        }
        
        if section.rawValue == .zero {
            return nil
        }
        
        let title = viewModel.sections[section.rawValue].title
        
        tableView.register(TableHeaderView.nib, forHeaderFooterViewReuseIdentifier: title)
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: title) as? TableHeaderView else {
            return UITableView.UISpacerView()
        }
        
        let cellViewModel = TableHeaderViewModel(title: title)
        
        header.viewModel = cellViewModel
        header.setTitle(title)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else {
            return .zero
        }
        
        switch section {
        case .display:
            return 32.0
            
        case .newRelease:
            return 16.0
            
        default:
            return 40.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UITableView.UISpacerView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else {
            return .zero
        }
        
        switch section {
        case .display:
            return 32.0
            
        default:
            return .zero
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let section = Section(rawValue: indexPath.section) else {
                return
            }
            
            switch section {
            case .display:
                break
            case .rated:
                if let c = tableView.cellForRow(at: indexPath) as? MediaHybridCell<RatingCollectionViewCell> {
                    
                    for (i, media) in c.cellViewModel.section.media.enumerated() where i < 5 {
                        let imageService = Application.app.server.imageService
                        let host = Application.app.server.hostProvider.absoluteString
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
            case .resumable:
                if let c = tableView.cellForRow(at: indexPath) as? MediaHybridCell<ResumingCollectionViewCell> {
                    
                    for (i, media) in c.cellViewModel.section.media.enumerated() where i < 5 {
                        let imageService = Application.app.server.imageService
                        let host = Application.app.server.hostProvider.absoluteString
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
            case .blockbuster:
                if let c = tableView.cellForRow(at: indexPath) as? MediaHybridCell<BrandCollectionViewCell> {
                    
                    for (i, media) in c.cellViewModel.section.media.enumerated() where i < 5 {
                        let imageService = Application.app.server.imageService
                        let host = Application.app.server.hostProvider.absoluteString
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
            default:
                if let c = tableView.cellForRow(at: indexPath) as? MediaHybridCell<PosterCollectionViewCell> {
                    
                    for (i, media) in c.cellViewModel.section.media.enumerated() where i < 5 {
                        let imageService = Application.app.server.imageService
                        let host = Application.app.server.hostProvider.absoluteString
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
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    }
}

// MARK: - Index Type

extension MediaTableViewDataSource {
    
    /// Section index representation type.
    enum Section: Int, CaseIterable {
        case display
        case newRelease
        case resumable
        case action
        case rated
        case sciFi
        case myList
        case blockbuster
        case crime
        case thriller
        case adventure
        case comedy
        case drama
        case horror
        case anime
        case familyNchildren
        case documentary
    }
}

// MARK: - State Type

extension MediaTableViewDataSource {
    
    /// Section state representation type.
    enum State: Int, CaseIterable {
        case all
        case tvShows
        case movies
    }
}
