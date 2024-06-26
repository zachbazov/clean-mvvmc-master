//
//  ProfileCollectionViewDataSource.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/10/2023.
//

import UIKit

final class ProfileCollectionViewDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let viewModel: ProfileViewModel
    
    weak var collectionView: UICollectionView?
    
    init(_ collectionView: UICollectionView, with viewModel: ProfileViewModel?) {
        guard let viewModel = viewModel else {
            fatalError()
        }
        
        self.viewModel = viewModel
        self.collectionView = collectionView
    }
    
    func dataSourceDidChange() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.profiles.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ProfileCollectionViewCell.create(in: collectionView, for: indexPath, with: viewModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileCollectionViewCell {
            cell.cellDidTap()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.opacityAnimation()
    }
}
