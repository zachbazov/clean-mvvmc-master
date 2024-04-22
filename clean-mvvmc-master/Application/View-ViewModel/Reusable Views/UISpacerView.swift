//
//  UISpacerView.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/10/2023.
//

import UIKit

extension UITableView {
    
    final class UISpacerView: UIView {
        
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
}
