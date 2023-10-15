//
//  UIViewController+Layout.swift
//  clean-mvvmc-master
//
//  Created by Developer on 13/10/2023.
//

import UIKit

// MARK: - Layout

extension UIViewController {
    
    func animateLayoutIfNeeded() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
