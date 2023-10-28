//
//  AvatarSelectorCollectionViewCellViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/10/2023.
//

import Foundation

struct AvatarSelectorCollectionViewCellViewModel {
    
    let image: String
    
    
    init(with model: Avatar) {
        self.image = model.image
    }
}
