//
//  GradientView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 29/09/2023.
//

import UIKit

@IBDesignable
final class GradientView: UIView {
    
    @IBInspectable
    var firstColor: UIColor = UIColor.black
    
    @IBInspectable
    var secondColor: UIColor = UIColor.black
    
    @IBInspectable
    var thirdColor: UIColor = UIColor.black
    
    @IBInspectable
    var reversedDrawing: Bool = false
    
    
    var gradientLayer: CAGradientLayer?
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer?.frame = bounds
            
            let colors = [firstColor, secondColor, thirdColor]
            
            if reversedDrawing {
                gradientLayer?.colors = colors.map { $0.cgColor }.reversed()
            } else {
                gradientLayer?.colors = colors.map { $0.cgColor }
            }
            
            layer.addSublayer(gradientLayer!)
        }
    }
    
    func redraw() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        
        setNeedsDisplay()
    }
}
