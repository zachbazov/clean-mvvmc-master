//
//  CollectionViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/10/2023.
//

import UIKit

protocol CollectionViewCell: UICollectionViewCell,
                             ViewInstantiable,
                             PathIndexable {
    
    func cellDidTap()
    func cellDidLongPress(_ gesture: UILongPressGestureRecognizer)
}


extension CollectionViewCell {
    
    static func create<T, U>(
        in collectionView: UICollectionView,
        for indexPath: IndexPath,
        with viewModel: U) -> T where T: CollectionViewCell, U: ViewModel {
            
            collectionView.register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
            
            guard let cell: T = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
                fatalError()
            }
            
            switch (cell, viewModel) {
                
            case (let cell as ProfileCollectionViewCell,
                  let viewModel as ProfileViewModel):
                
                let model = viewModel.profiles.value[indexPath.row]
                let cellViewModel = ProfileCollectionViewCellViewModel(with: model)
                
                cell.tag = indexPath.row
                cell.indexPath = indexPath
                cell.viewModel = viewModel
                cell.cellViewModel = cellViewModel
                cell.deploySubviews()
                
                return cell as! T
                
            case (let cell as AvatarSelectorCollectionViewCell,
                  let viewModel as ProfileViewModel):
                
                let avatars: [Avatar] = viewModel.avatars.toDomain()
                let model = avatars[indexPath.row]
                let cellViewModel = AvatarSelectorCollectionViewCellViewModel(with: model)
                
                cell.indexPath = indexPath
                cell.viewModel = viewModel
                cell.cellViewModel = cellViewModel
                cell.deploySubviews()
                
                return cell as! T
                
            default:
                fatalError()
            }
        }
}
