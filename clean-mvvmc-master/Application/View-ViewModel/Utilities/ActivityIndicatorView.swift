//
//  ActivityIndicatorView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 12/11/2023.
//

import UIKit

class ActivityIndicatorView: UIView {
    
    private var isAnimating = false
    
    private var startColor: UIColor = UIColor.black
    private var endColor: UIColor = UIColor.hexColor("#E50914")
    
    private var lineWidth: CGFloat = 4.0
    private var endLineWidth: CGFloat = 2.0
    
    func startAnimating() {
        guard !isAnimating else { return }
        
        isAnimating = true
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi * 2.0
        rotationAnimation.duration = 1.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .infinity
        
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopAnimating() {
        layer.removeAnimation(forKey: "rotationAnimation")
        isAnimating = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.clear.setFill()
        
        let centerX = rect.width / 2
        let centerY = rect.height / 2
        
        let radius = min(rect.width, rect.height) / 2 - 4.0
        
        let gradient = CAGradientLayer()
        gradient.frame = rect
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.2, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = circlePath.cgPath
        borderLayer.lineWidth = lineWidth
        borderLayer.lineCap = .round
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        gradient.mask = borderLayer
        
        layer.addSublayer(gradient)
    }
}
