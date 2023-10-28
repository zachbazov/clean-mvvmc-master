//
//  CollectionViewDataSource.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

//protocol CollectionViewDataSource: UICollectionViewDelegate, UICollectionViewDataSource {
    
//    associatedtype ViewModelType
//    
//    associatedtype CellType: CollectionViewCell
//    
//    var viewModel: ViewModelType { get }
//    
//    var collectionView: UICollectionView? { get }
//    
//    init(_ collectionView: UICollectionView, with viewModel: ViewModelType?)
    
//    func dataSourceDidChange()
    
//    func numberOfSections() -> Int
//    
//    func numberOfItems(in section: Int) -> Int
//    
//    func cellForItem<T>(at indexPath: IndexPath) -> T where T: CollectionViewCell
//}

//extension CollectionViewDataSource {
//    
//    func dataSourceDidChange() {
//        
//    }
//    
//    func numberOfSections() -> Int {
//        return .zero
//    }
//    
//    func numberOfItems(in section: Int) -> Int {
//        return .zero
//    }
//    
//    func cellForItem<T>(at indexPath: IndexPath) -> T where T: CollectionViewCell {
//        return .init()
//    }
//}


//class CVDataSource: NSObject, CollectionViewDataSource {
//    
//    func dataSourceDidChange() {
//        
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return numberOfSections()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return numberOfItems(in: section)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return cellForItem(at: indexPath)
//    }
//    
//    func numberOfSections() -> Int {
//        return 1
//    }
//    
//    func numberOfItems(in section: Int) -> Int {
//        return .zero
//    }
//    
//    func cellForItem<T>(at indexPath: IndexPath) -> T where T: CollectionViewCell {
//        return .init()
//    }
//}
