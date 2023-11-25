//
//  CollectionViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/10/2023.
//

import UIKit

@objc
protocol UICollectionViewCellInteracting {
    @objc optional func cellDidTap()
    @objc optional func cellDidLongPress(_ gesture: UILongPressGestureRecognizer)
}

extension UICollectionViewCell: ViewInstantiable,
                                PathIndexable,
                                UICollectionViewCellInteracting {
    
    static func create<T, U>(in collectionView: UICollectionView,
                             for indexPath: IndexPath,
                             typeOf type: T.Type,
                             section: Section? = nil,
                             with viewModel: U) -> T where T: UICollectionViewCell, U: ViewModel {
        
        collectionView.register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        
        switch (cell, viewModel) {
            
        case (let cell as ProfileCollectionViewCell, let viewModel as ProfileViewModel):
            
            let model = viewModel.profiles.value[indexPath.row]
            let cellViewModel = ProfileCollectionViewCellViewModel(with: model)
            
            cell.tag = indexPath.row
            cell.indexPath = indexPath
            cell.viewModel = viewModel
            cell.cellViewModel = cellViewModel
            cell.deploySubviews()
            
        case (let cell as AvatarSelectorCollectionViewCell, let viewModel as ProfileViewModel):
            
            let avatars: [Avatar] = viewModel.avatars.toDomain()
            let model = avatars[indexPath.row]
            let cellViewModel = AvatarSelectorCollectionViewCellViewModel(with: model)
            
            cell.indexPath = indexPath
            cell.viewModel = viewModel
            cell.cellViewModel = cellViewModel
            cell.deploySubviews()
            
        case (let cell as RatingCollectionViewCell, _ as HomeViewModel):
            
            let media = section?.media[indexPath.row] ?? .vacantValue
            let cellViewModel = MediaCollectionViewCellViewModel(media: media)
            
            cell.indexPath = indexPath
            cell.viewModel = cellViewModel
            cell.deploySubviews()
            
        case (let cell as PosterCollectionViewCell, _ as HomeViewModel):
            
            let media = section?.media[indexPath.row] ?? .vacantValue
            let cellViewModel = MediaCollectionViewCellViewModel(media: media)
            
            cell.indexPath = indexPath
            cell.viewModel = cellViewModel
            cell.deploySubviews()
            
        case (let cell as ResumingCollectionViewCell, _ as HomeViewModel):
            
            let media = section?.media[indexPath.row] ?? .vacantValue
            let cellViewModel = MediaCollectionViewCellViewModel(media: media)
            
            cell.indexPath = indexPath
            cell.viewModel = cellViewModel
            cell.deploySubviews()
            
        case (let cell as BrandCollectionViewCell, _ as HomeViewModel):
            
            let media = section?.media[indexPath.row] ?? .vacantValue
            let cellViewModel = MediaCollectionViewCellViewModel(media: media)
            
            cell.indexPath = indexPath
            cell.viewModel = cellViewModel
            cell.deploySubviews()
            
        default:
            fatalError()
        }
        
        return cell
    }
}
