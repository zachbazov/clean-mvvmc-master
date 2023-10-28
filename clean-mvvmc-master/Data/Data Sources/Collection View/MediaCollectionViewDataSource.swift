//
//  MediaCollectionViewDataSource.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

final class MediaCollectionViewDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let viewModel: HomeViewModel
    
    weak var collectionView: UICollectionView?
    
    
    init(_ collectionView: UICollectionView, with viewModel: HomeViewModel?) {
        guard let viewModel = viewModel else {
            fatalError()
        }
        
        self.viewModel = viewModel
        self.collectionView = collectionView
    }
    
    
    func dataSourceDidChange() {
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
