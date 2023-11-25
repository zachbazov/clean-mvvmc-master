//
//  HybridCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/11/2023.
//

import UIKit

protocol HybridCell: UITableViewCell, ViewLifecycleBehavior {
    
    associatedtype EmbeddedCellType: UICollectionViewCell
    associatedtype DataSourceType: UICollectionViewDataSource
    associatedtype ViewModelType: ViewModel
    
    var collectionView: UICollectionView! { get set }
    var embeddedCell: EmbeddedCellType? { get set }
    var dataSource: DataSourceType? { get set }
    var viewModel: ViewModelType! { get set }
    var layout: CollectionViewLayout! { get set }
}


extension HybridCell {
    
    static func create<T>(in tableView: UITableView,
                          for indexPath: IndexPath,
                          embeddingWith type: T.Type,
                          with viewModel: ViewModelType) -> T where T: UITableViewCell {
        
        tableView.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        
        switch (cell, viewModel) {
            
        case (let cell as MediaHybridCell<EmbeddedCellType>, let viewModel as HomeViewModel):
            
            let section = viewModel.sections[indexPath.section]
            let cellViewModel = MediaHybridCellViewModel(section: section)
            
            cell.viewModel = viewModel
            cell.cellViewModel = cellViewModel
            cell.deploySubviews()
            
        default:
            fatalError()
        }
        
        return cell
    }
}


final class MediaHybridCell<EmbeddedCellType>: UITableViewCell, HybridCell where EmbeddedCellType: UICollectionViewCell {
    
    lazy var collectionView: UICollectionView! = createCollectionView()
    
    var cell: MediaHybridCell<EmbeddedCellType>?
    
    var embeddedCell: EmbeddedCellType?
    
    var dataSource: MediaCollectionViewDataSource<EmbeddedCellType>?
    
    var viewModel: HomeViewModel!
    
    var layout: CollectionViewLayout!
    
    var cellViewModel: MediaHybridCellViewModel!
    
    deinit {
        deallocateSubviews()
    }
    
    
    func deploySubviews() {
        
        configureSubviews()
        
        createCollectionLayout()
        createDataSource()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureSubviews() {
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        collectionView.backgroundColor = .clear
        
        contentView.addSubview(collectionView)
    }
    
    func deallocateSubviews() {
        
        collectionView?.removeFromSuperview()
        cell?.removeFromSuperview()
        
        cell = nil
        collectionView = nil
        dataSource = nil
        viewModel = nil
        layout = nil
        
        removeFromSuperview()
    }
    
    
    private func createCollectionView() -> UICollectionView {
        
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: .init())
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EmbeddedCellType.nib, forCellWithReuseIdentifier: EmbeddedCellType.reuseIdentifier)
        
        return collectionView
    }
    
    private func createDataSource() {
        
        dataSource = MediaCollectionViewDataSource<EmbeddedCellType>(collectionView, section: cellViewModel.section, with: viewModel)
        
        dataSource?.dataSourceDidChange()
    }
    
    private func createCollectionLayout() {
        
        guard let section = MediaTableViewDataSource.Section(rawValue: cellViewModel.section.id) else {
            return
        }
        
        switch section {
            
        case .display:
            return
            
        case .newRelease:
            
            layout = CollectionViewLayout(layout: .standard, scrollDirection: .horizontal)
            
        case .rated:
            
            layout = CollectionViewLayout(layout: .rated, scrollDirection: .horizontal)
            
        case .blockbuster:
            
            layout = CollectionViewLayout(layout: .blockbuster, scrollDirection: .horizontal)
            
        default:
            
            layout = CollectionViewLayout(layout: .standard, scrollDirection: .horizontal)
            
        }
        
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
}

struct MediaHybridCellViewModel {
    
    var section: Section
}


/*
 protocol HybridCell: UITableViewCell, ViewLifecycleBehavior {
     
     associatedtype EmbeddedCellType: UICollectionViewCell
     associatedtype DataSourceType: UICollectionViewDataSource
     associatedtype ViewModelType: ViewModel
     
     var collectionView: UICollectionView! { get set }
     var embeddedCell: EmbeddedCellType? { get set }
     var dataSource: DataSourceType? { get set }
     var viewModel: ViewModelType! { get set }
     var layout: CollectionViewLayout! { get set }
 }


 extension HybridCell {
     
     static func create<T>(in tableView: UITableView,
                           for indexPath: IndexPath,
                           embeddingWith type: T.Type,
                           with viewModel: ViewModelType) -> T where T: UITableViewCell {
         
         tableView.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
         print(T.self)
         guard let cell = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
             fatalError()
         }
         
         switch (cell, viewModel) {
             
         case (let cell as MediaHybridCell<EmbeddedCellType>, let viewModel as HomeViewModel):
             
             let section = viewModel.sections[indexPath.section]
             let cellViewModel = MediaHybridCellViewModel(section: section)
             
             cell.viewModel = viewModel
             cell.cellViewModel = cellViewModel
             cell.deploySubviews()
             
         default:
             fatalError()
         }
         
         return cell
     }
 }


 final class MediaHybridCell<EmbeddedCellType>: UITableViewCell, HybridCell where EmbeddedCellType: UICollectionViewCell {
     
     lazy var collectionView: UICollectionView! = createCollectionView()
     
     var cell: MediaHybridCell<EmbeddedCellType>?
     
     var embeddedCell: EmbeddedCellType?
     
     var dataSource: MediaCollectionViewDataSource<EmbeddedCellType>?
     
     var viewModel: HomeViewModel!
     
     var layout: CollectionViewLayout!
     
     var cellViewModel: MediaHybridCellViewModel!
     
     deinit {
         deallocateSubviews()
     }
     
     
     func deploySubviews() {
         
         configureSubviews()
         
         createCollectionLayout()
         createDataSource()
     }
     
     func configureHierarchy() {
         
     }
     
     func configureSubviews() {
         
         backgroundColor = .clear
         contentView.backgroundColor = .clear
         
         collectionView.backgroundColor = .clear
         
         contentView.addSubview(collectionView)
     }
     
     func deallocateSubviews() {
         
         collectionView?.removeFromSuperview()
         cell?.removeFromSuperview()
         
         cell = nil
         collectionView = nil
         dataSource = nil
         viewModel = nil
         layout = nil
         
         removeFromSuperview()
     }
     
     
     private func createCollectionView() -> UICollectionView {
         
         let collectionView = UICollectionView(frame: bounds, collectionViewLayout: .init())
         
         collectionView.showsVerticalScrollIndicator = false
         collectionView.showsHorizontalScrollIndicator = false
         collectionView.register(EmbeddedCellType.nib, forCellWithReuseIdentifier: EmbeddedCellType.reuseIdentifier)
         
         return collectionView
     }
     
     private func createDataSource() {
         
         dataSource = MediaCollectionViewDataSource<EmbeddedCellType>(collectionView, section: cellViewModel.section, with: viewModel)
         
         dataSource?.dataSourceDidChange()
     }
     
     private func createCollectionLayout() {
         
         guard let section = MediaTableViewDataSource.Section(rawValue: cellViewModel.section.id) else {
             return
         }
         
         switch section {
             
         case .display:
             return
             
         case .newRelease:
             
             layout = CollectionViewLayout(layout: .standard, scrollDirection: .horizontal)
             
         case .rated:
             
             layout = CollectionViewLayout(layout: .rated, scrollDirection: .horizontal)
             
         case .blockbuster:
             
             layout = CollectionViewLayout(layout: .blockbuster, scrollDirection: .horizontal)
             
         default:
             
             layout = CollectionViewLayout(layout: .standard, scrollDirection: .horizontal)
             
         }
         
         collectionView.setCollectionViewLayout(layout, animated: false)
     }
 }

 struct MediaHybridCellViewModel {
     
     var section: Section
 }

 */
