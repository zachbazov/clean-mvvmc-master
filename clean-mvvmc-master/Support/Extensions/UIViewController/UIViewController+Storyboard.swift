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
        switch self.reuseIdentifier {
        case TabBarController.reuseIdentifier:
            return UIStoryboard(name: TabBarController.reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: TabBarController.reuseIdentifier)
        default:
            return nil
        }
    }
}
