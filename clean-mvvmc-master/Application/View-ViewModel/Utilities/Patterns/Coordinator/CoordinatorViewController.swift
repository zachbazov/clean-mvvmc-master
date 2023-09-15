//
//  CoordinatorViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import Foundation

protocol CoordinatorViewController {
    
    associatedtype ViewModelType: CoordinatorViewModel
    
    var controllerViewModel: ViewModelType? { get }
}
