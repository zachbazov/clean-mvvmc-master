//
//  UIView+Animation.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/11/2023.
//

import UIKit

extension UIView {
    
    func opacityAnimation(withDelay delay: TimeInterval) {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.duration = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation]
        animationGroup.duration = 0.5
        animationGroup.beginTime = CACurrentMediaTime() + delay
        
        layer.add(animationGroup, forKey: "opacity")
    }
}
