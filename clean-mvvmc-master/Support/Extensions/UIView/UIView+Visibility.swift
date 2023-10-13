//
//  UIView+Visibility.swift
//  clean-mvvmc-master
//
//  Created by Developer on 13/10/2023.
//

import UIKit

// MARK: - Visibility

extension UIView {
    
    func reveal() {
        alpha = 1.0
    }
    
    func conceal() {
        alpha = .zero
    }
}
