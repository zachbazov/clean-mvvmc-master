//
//  UIImage+Drawing.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/11/2023.
//

import UIKit

// MARK: - Drawings

extension UIImage {
    
    func scale(newWidth: CGFloat,
               cornerRadius: CGFloat = 0.0,
               borderWidth: CGFloat = 1.0,
               borderColor: UIColor = .white) -> UIImage {
        guard self.size.width != newWidth else { return self }
        
        let scaleFactor = newWidth / self.size.width
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        let roundedRect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        let roundedPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius).cgPath
        
        context?.addPath(roundedPath)
        context?.clip()
        
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        context?.setStrokeColor(borderColor.cgColor)
        context?.setLineWidth(borderWidth)
        context?.addPath(roundedPath)
        context?.strokePath()
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}

