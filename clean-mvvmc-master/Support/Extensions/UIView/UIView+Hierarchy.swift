//
//  UIView+Hierarchy.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/10/2023.
//

import UIKit

extension UIView {
    
    func addToHierarchy(in parent: UIView) -> Self {
        
        parent.addSubview(self)
        
        return self
    }
}
