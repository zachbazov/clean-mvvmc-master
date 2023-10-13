//
//  UIViewController+Storyboard.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit
import CodeBureau

extension UIViewController: Reusable {
    
    public static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UIViewController: StoryboardInstantiable {
    
    public static var xib: UIViewController? {
        switch reuseIdentifier {
        case AuthViewController.reuseIdentifier:
            return UIStoryboard(name: reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
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
