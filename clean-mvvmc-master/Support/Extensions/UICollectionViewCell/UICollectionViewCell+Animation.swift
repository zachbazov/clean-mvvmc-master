//
//  UICollectionViewCell+Animation.swift
//  clean-mvvmc-master
//
//  Created by Developer on 28/10/2023.
//

import UIKit

extension UICollectionViewCell {
    
    func opacityAnimation() {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.duration = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        
        layer.add(animation, forKey: "opacity")
    }
}
