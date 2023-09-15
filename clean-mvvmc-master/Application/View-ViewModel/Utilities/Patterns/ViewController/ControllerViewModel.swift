//
//  ControllerViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import Foundation

protocol ControllerViewModel {
    
    associatedtype CoordinatorType: Coordinator
    
    var coordinator: CoordinatorType? { get }
}
