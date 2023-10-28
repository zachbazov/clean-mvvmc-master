//
//  Coordinator.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

// MARK: - Coordinator Type

protocol Coordinator {
    
    associatedtype ViewControllerType: UIViewController
    
    var viewController: ViewControllerType? { get }
}
