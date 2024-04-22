//
//  ShimmerView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/11/2023.
//

import UIKit

// MARK: - ShimmerView Type

final class ShimmerView: UIView {
    
    static let uniqueIdentifier: Int = 0x77
    
    private(set) var gradientLayer = CAGradientLayer()
    
    private weak var parent: UIView!
    
    
    init(on parent: UIView) {
        self.parent = parent
        
        super.init(frame: parent.bounds)
        
        self.configure()
        self.animate()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = CGRect(x: .zero, y: .zero,
                                     width: parent.bounds.width,
                                     height: parent.bounds.height)
    }
}


extension ShimmerView {
    
    private func configure() {
        
        parent.addSubview(self)
        parent.clipsToBounds = true
        
        layer.addSublayer(gradientLayer)
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.hexColor("#292929").cgColor,
                                UIColor.clear.cgColor]
    }
    
    private func animate() {
        
        let startPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        let endPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        
        startPointAnimation.fromValue = CGPoint(x: -2.0, y: -1.0)
        startPointAnimation.toValue = CGPoint(x: 2.0, y: 2.0)
        endPointAnimation.fromValue = CGPoint(x: 0.0, y: 0.0)
        endPointAnimation.toValue = CGPoint(x: 2.0, y: 2.0)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [startPointAnimation, endPointAnimation]
        animationGroup.duration = 1.5
        animationGroup.repeatCount = .infinity
        
        gradientLayer.add(animationGroup, forKey: nil)
    }
    
    func removeAnimation() {
        gradientLayer.removeAllAnimations()
    }
}


extension UIView {
    
    func addShimmer() {
        
        let shimmerView = ShimmerView(on: self)
        
        shimmerView.tag = ShimmerView.uniqueIdentifier
    }
    
    func removeShimmer() {
        
        if let shimmerView = subviews.first(where: { $0.tag == ShimmerView.uniqueIdentifier }) as? ShimmerView {
            
            shimmerView.gradientLayer.removeAllAnimations()
            
            shimmerView.removeFromSuperview()
        }
    }
}

/*
 // MARK: - ShimmerView Type

 final class ShimmerView: UIView {
     
     private let gradientLayer = CAGradientLayer()
     
     private weak var parent: UIView!
     
     
     init(on parent: UIView) {
         self.parent = parent
         
         super.init(frame: parent.bounds)
         
         self.configure()
         self.animate()
     }
     
     required init?(coder: NSCoder) {
         fatalError()
     }
     
     
     override func layoutSubviews() {
         super.layoutSubviews()
         
         gradientLayer.frame = CGRect(x: .zero, y: .zero,
                                      width: parent.bounds.width,
                                      height: parent.bounds.height)
     }
 }


 extension ShimmerView {
     
     private func configure() {
         
         parent.addSubview(self)
         parent.clipsToBounds = true
         
         layer.addSublayer(gradientLayer)
         
         gradientLayer.locations = [0.0, 1.0]
         gradientLayer.colors = [UIColor.clear.cgColor,
                                 UIColor.hexColor("#292929").cgColor,
                                 UIColor.clear.cgColor]
     }
     
     private func animate() {
         
         let startPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
         let endPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
         
         startPointAnimation.fromValue = CGPoint(x: -2, y: -1)
         startPointAnimation.toValue = CGPoint(x: 2, y: 2)
         endPointAnimation.fromValue = CGPoint(x: 0, y: 0)
         endPointAnimation.toValue = CGPoint(x: 2, y: 2)
         
         let animationGroup = CAAnimationGroup()
         animationGroup.animations = [startPointAnimation, endPointAnimation]
         animationGroup.duration = 1.5
         animationGroup.repeatCount = .infinity
         
         gradientLayer.add(animationGroup, forKey: nil)
     }
 }

 */
