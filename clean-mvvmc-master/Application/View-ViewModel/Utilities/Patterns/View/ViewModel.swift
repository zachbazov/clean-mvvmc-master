//
//  ViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

protocol ViewModel {
    
    associatedtype ModelType
    
    
    init(with model: ModelType)
}
