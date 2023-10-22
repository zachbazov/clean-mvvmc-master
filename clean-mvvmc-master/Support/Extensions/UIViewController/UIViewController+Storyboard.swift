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
            
        case SignUpViewController.reuseIdentifier:
            return UIStoryboard(name: AuthViewController.reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
            
        case SignInViewController.reuseIdentifier:
            return UIStoryboard(name: AuthViewController.reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
            
        case ProfileViewController.reuseIdentifier:
            return UIStoryboard(name: reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
            
        case AddProfileViewController.reuseIdentifier:
            return UIStoryboard(name: ProfileViewController.reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
            
        case EditProfileViewController.reuseIdentifier:
            return UIStoryboard(name: ProfileViewController.reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
            
        case TabBarController.reuseIdentifier:
            return UIStoryboard(name: reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
            
        case DetailViewController.reuseIdentifier:
            return UIStoryboard(name: reuseIdentifier, bundle: nil)
                .instantiateViewController(withIdentifier: reuseIdentifier)
            
        default:
            fatalError("\(Self.self) should be instantiated by a xib object using the `instantiateViewController(withIdentifier:) method.")
        }
    }
}
