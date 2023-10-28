//
//  UICollectionTypeSpacer.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/10/2023.
//

import UIKit

final class UICollectionTypeSpacer: UIView {
    
    init() {
        super.init(frame: .zero)
        
        self.configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configureSubviews() {
        backgroundColor = .clear
    }
}
