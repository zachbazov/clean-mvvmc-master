//
//  UIHybridTableViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/11/2023.
//

import UIKit

protocol Hybridable: UITableViewCell {
    
    associatedtype EmbeddedCellType: UICollectionViewCell
    associatedtype DataSourceType: UICollectionViewDataSource
    associatedtype ViewModelType: ViewModel
    
    var collectionView: UICollectionView! { get set }
    var layout: CollectionViewLayout! { get set }
    var dataSource: DataSourceType! { get set }
    var viewModel: ViewModelType! { get set }
}

final class UIHybridTableViewCell<EmbeddedCellType>: UITableViewCell, Hybridable where EmbeddedCellType: UICollectionViewCell {
    
    lazy var collectionView: UICollectionView! = createCollectionView()
    lazy var layout: CollectionViewLayout! = createCollectionLayout()
    var dataSource: MediaCollectionViewDataSource<EmbeddedCellType>!
    
    var viewModel: HomeViewModel!
    var cellViewModel: UIHybridTableViewCellViewModel!
    
    static func create<T>(in tableView: UITableView,
                          for indexPath: IndexPath,
                          with viewModel: ViewModelType) -> T where T: UITableViewCell {
        
        tableView.register(Self.self, forCellReuseIdentifier: Self.reuseIdentifier)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        
        switch (cell, viewModel) {
            
        case (let cell as UIHybridTableViewCell<EmbeddedCellType>, let viewModel):
            
            let section = viewModel.sections[indexPath.section]
            let cellViewModel = UIHybridTableViewCellViewModel(section: section)
            
            cell.viewModel = viewModel
            cell.cellViewModel = cellViewModel
            cell.deploySubviews()
            
        default:
            fatalError()
        }
        
        return cell
    }
    
    deinit {
        deallocateSubviews()
    }
    
    func deploySubviews() {
        configureSubviews()
        
        createDataSource()
    }
    
    func configureSubviews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(collectionView)
    }
    
    func deallocateSubviews() {
        collectionView?.removeFromSuperview()
        collectionView = nil
        dataSource = nil
        viewModel = nil
        layout = nil
        
        removeFromSuperview()
    }
    
    private func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }
    
    private func createCollectionLayout() -> CollectionViewLayout? {
        guard let section = MediaTableViewDataSource.Section(rawValue: cellViewModel.section.id) else {
            return nil
        }
        
        switch section {
            
        case .display:
            return nil
            
        case .newRelease:
            return CollectionViewLayout(layout: .standard, scrollDirection: .horizontal)
            
        case .rated:
            return CollectionViewLayout(layout: .rated, scrollDirection: .horizontal)
            
        case .blockbuster:
            return CollectionViewLayout(layout: .blockbuster, scrollDirection: .horizontal)
            
        default:
            return CollectionViewLayout(layout: .standard, scrollDirection: .horizontal)
        }
    }
    
    private func createDataSource() {
        dataSource = MediaCollectionViewDataSource<EmbeddedCellType>(collectionView, section: cellViewModel.section, with: viewModel)
        
        dataSource?.dataSourceDidChange()
    }
}

struct UIHybridTableViewCellViewModel {
    let section: Section
}







final class UIHybridDetailTableViewCell<EmbeddedCellType>: UITableViewCell, Hybridable where EmbeddedCellType: UICollectionViewCell {
    
    lazy var collectionView: UICollectionView! = createCollectionView()
    lazy var layout: CollectionViewLayout! = createCollectionLayout()
    var dataSource: DetailMediaCollectionViewDataSource<EmbeddedCellType>!
    
    var viewModel: DetailViewModel!
    var cellViewModel: UIHybridDetailTableViewCellViewModel!
    
    static func create<T>(in tableView: UITableView,
                          for indexPath: IndexPath,
                          with viewModel: ViewModelType) -> T where T: UITableViewCell {
        
        tableView.register(Self.self, forCellReuseIdentifier: Self.reuseIdentifier)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        
        switch (cell, viewModel) {
            
        case (let cell as UIHybridDetailTableViewCell<EmbeddedCellType>, let viewModel):
            
            let section = viewModel.dependencies.section
            let cellViewModel = UIHybridDetailTableViewCellViewModel(section: section)
            
            cell.viewModel = viewModel
            cell.cellViewModel = cellViewModel
            cell.deploySubviews()
            
        default:
            fatalError()
        }
        
        return cell
    }
    
    deinit {
        deallocateSubviews()
    }
    
    func deploySubviews() {
        configureSubviews()
        
        createDataSource()
    }
    
    func configureSubviews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(collectionView)
    }
    
    func deallocateSubviews() {
        collectionView?.removeFromSuperview()
        collectionView = nil
        dataSource = nil
        viewModel = nil
        layout = nil
        
        removeFromSuperview()
    }
    
    private func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }
    
    private func createCollectionLayout() -> CollectionViewLayout? {
        return CollectionViewLayout(layout: .detail, scrollDirection: .horizontal)
    }
    
    private func createDataSource() {
        dataSource = DetailMediaCollectionViewDataSource<EmbeddedCellType>(collectionView, section: cellViewModel.section, with: viewModel)
        
        dataSource?.dataSourceDidChange()
    }
}

struct UIHybridDetailTableViewCellViewModel {
    let section: Section
}

final class DetailMediaCollectionViewDataSource<Cell>: NSObject,
                                                       UICollectionViewDelegate,
                                                       UICollectionViewDataSource,
                                                       UICollectionViewDataSourcePrefetching where Cell: UICollectionViewCell {
    
    private weak var collectionView: UICollectionView?
    private let viewModel: DetailViewModel
    private let section: Section
    
    init(_ collectionView: UICollectionView, section: Section, with viewModel: DetailViewModel) {
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
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return PosterCollectionViewCell.create(in: collectionView, for: indexPath, section: self.section, with: viewModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.opacityAnimation()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MediaCollectionViewCell {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let media = section.media[indexPath.row]
            
            media.prefetchResources()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    }
}
