//
//  UITableViewCell+Animation.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/11/2023.
//

import UIKit

// MARK: - Opacity Animation

extension UITableViewCell {
    
    func opacityAnimation() {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.duration = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        
        layer.add(animation, forKey: "opacity")
    }
}
