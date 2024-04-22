//
//  ViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import Foundation

// MARK: - ViewController Type

protocol ViewController: ViewControllerLifecycleBehavior {
    
    associatedtype ViewModelType: ViewModel
    
    var viewModel: ViewModelType! { get }
}
