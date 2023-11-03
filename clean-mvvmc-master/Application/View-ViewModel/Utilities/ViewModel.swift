//
//  ViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import Foundation

// MARK: - ViewModel Type

protocol ViewModel {
    
    associatedtype CoordinatorType: Coordinator
    
    var coordinator: CoordinatorType? { get }
}
