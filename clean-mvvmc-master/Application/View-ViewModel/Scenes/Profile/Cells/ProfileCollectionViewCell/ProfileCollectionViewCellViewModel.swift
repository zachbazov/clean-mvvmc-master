//
//  ProfileCollectionViewCellViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

struct ProfileCollectionViewCellViewModel {
    
    let id: String
    let image: String
    let name: String
    var isLongPressed: Bool = false
    
    var centerPoint: CGPoint?
    
    
    init(with model: Profile) {
        self.id = model._id ?? ""
        self.image = model.image
        self.name = model.name
    }
}
