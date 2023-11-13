//
//  UIButton+Effect.swift
//  clean-mvvmc-master
//
//  Created by Developer on 13/11/2023.
//

import UIKit

// MARK: - Scaling Effect

extension UIButton {
    
    func scalingEffect(_ completion: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }, completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            }, completion: { _ in
                
                completion?()
            })
        })
    }
}
