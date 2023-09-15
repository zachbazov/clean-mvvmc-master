//
//  View.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

protocol View: UIView {
    
    associatedtype ViewModelType: ViewModel
    
    var viewModel: ViewModelType? { get }
    
    
    init(on parent: UIView, with viewModel: ViewModelType)
    
    
    func updateView(with viewModel: ViewModelType?)
}
