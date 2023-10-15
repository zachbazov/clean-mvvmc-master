//
//  BorderedButton.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import UIKit

@IBDesignable
final class BorderedButton: UIButton {
    
    @IBInspectable
    var borderWidth: CGFloat = .zero
    
    @IBInspectable
    var borderColor: UIColor = .clear
    
    @IBInspectable
    var cornerRadius: CGFloat = .zero
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//        borderColor.setStroke()
//        path.lineWidth = borderWidth
//        path.stroke()
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
}
