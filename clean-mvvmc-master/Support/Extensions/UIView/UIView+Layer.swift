//
//  UIView+Layer.swift
//  clean-mvvmc-master
//
//  Created by Developer on 24/11/2023.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.setNeedsDisplay()
        }
    }
}
