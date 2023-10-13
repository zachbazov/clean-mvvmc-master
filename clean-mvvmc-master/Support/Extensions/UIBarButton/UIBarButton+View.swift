//
//  UIBarButton+View.swift
//  clean-mvvmc-master
//
//  Created by Developer on 13/10/2023.
//

import UIKit

extension UIBarButtonItem {
    
    var view: UIView? {
        return value(forKey: "view") as? UIView
    }
}
