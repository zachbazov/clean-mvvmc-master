//
//  RatingCollectionViewCell.swift
//  clean-mvvmc-master
//
//  Created by Developer on 19/11/2023.
//

import UIKit

final class RatingCollectionViewCell: MediaCollectionViewCell {
    
    private let layerView = UIView()
    private let textLayer = UITextLayer()
    
    private let fontSize: CGFloat = 112.0
    
    
    deinit {
        deallocateSubviews()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layerView.frame = CGRect(x: .zero, y: frame.maxY - fontSize, width: bounds.width, height: bounds.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLayer.string = nil
    }
    
    
    override func deploySubviews() {
        super.deploySubviews()
        
        contentView.addSubview(layerView)
        
        if indexPath.row == .zero {
            textLayer.frame = CGRect(x: 8.0, y: -4.0, width: bounds.width, height: bounds.height)
        } else {
            textLayer.frame = CGRect(x: -16.0, y: -4.0, width: bounds.width, height: bounds.height)
        }
        
        let index = String(describing: indexPath.row + 1)
        
        let attributedString = NSAttributedString(
            string: index,
            attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .bold),
                         .strokeColor: UIColor.white,
                         .strokeWidth: -2.5,
                         .foregroundColor: UIColor.black.cgColor])
        
        layerView.layer.insertSublayer(textLayer, at: 1)
        
        textLayer.string = attributedString
    }
    
    func deallocateSubviews() {
        textLayer.removeFromSuperlayer()
        layerView.removeFromSuperview()
        
        removeFromSuperview()
    }
}


extension RatingCollectionViewCell {
    
    private final class UITextLayer: CATextLayer {
        
        override func draw(in ctx: CGContext) {
            
            ctx.saveGState()
            ctx.translateBy(x: .zero, y: .zero)
            
            super.draw(in: ctx)
            
            ctx.restoreGState()
        }
    }
}
