//
//  UIViewController+Storyboard.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

extension UIViewController {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    static var xib: UIViewController? {
        switch reuseIdentifier {
        case TabBarController.reuseIdentifier:
            return UIStoryboard(name: reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
        case DeltaViewController.reuseIdentifier:
            return UIStoryboard(name: reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
        case OmegaViewController.reuseIdentifier:
            return UIStoryboard(name: reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
        default:
            fatalError("\(Self.self) should be instantiated by a xib object using the `instantiateViewController(withIdentifier:) method.")
        }
    }
}
