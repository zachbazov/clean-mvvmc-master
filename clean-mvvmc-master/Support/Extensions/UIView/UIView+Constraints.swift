//
//  UIView+Constraints.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/10/2023.
//

import UIKit

extension UIView {
    
    @discardableResult
    func constraint(to parent: UIView) -> Self {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
        
        return self
    }
    
    func constraint(to parent: UIView, with size: CGSize) -> Self {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            centerYAnchor.constraint(equalTo: parent.centerYAnchor),
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
        
        return self
    }
}
