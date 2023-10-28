//
//  UIEdgeInsets+Init.swift
//  clean-mvvmc-master
//
//  Created by Developer on 24/10/2023.
//

import UIKit

extension UIEdgeInsets {
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
