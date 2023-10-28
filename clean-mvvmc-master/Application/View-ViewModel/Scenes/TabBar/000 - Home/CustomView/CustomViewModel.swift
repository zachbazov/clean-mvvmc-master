//
//  CustomViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import Foundation

struct CustomViewModel {
    
    let title: String
    
    
    init(with model: Profile) {
        self.title = model.name
    }
}
