//
//  CollectionViewDataSource.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

protocol CollectionViewDataSource: UICollectionViewDelegate, UICollectionViewDataSource {
    
    associatedtype T
    
    var viewModel: T { get }
    
    var collectionView: UICollectionView? { get }
    
    init(_ collectionView: UICollectionView, with viewModel: T)
    
    func dataSourceDidChange()
}
