//
//  Theme.swift
//  clean-mvvmc-master
//
//  Created by Developer on 28/09/2023.
//

import UIKit

class Theme {
    
    enum ThemeType {
        case light
        case dark
    }
    
    
    static var currentTheme: ThemeType = .dark
    
    static var barButtonTitleTextAttributes: [NSAttributedString.Key: Any] {
        return currentTheme == .dark
            ? [.foregroundColor: UIColor.white,
               .font: UIFont.systemFont(ofSize: 16.0, weight: .heavy)]
            : [.foregroundColor: UIColor.black,
               .font: UIFont.systemFont(ofSize: 16.0, weight: .heavy)]
    }
    
    static var navigationBarTitleTextAttributes: [NSAttributedString.Key: Any] {
        return currentTheme == .dark
            ? [.foregroundColor: UIColor.white,
               .font: UIFont.systemFont(ofSize: 17.0, weight: .bold)]
            : [.foregroundColor: UIColor.black,
               .font: UIFont.systemFont(ofSize: 17.0, weight: .bold)]
    }
    
    static var navigationBarBackgroundColor: UIColor {
        return currentTheme == .dark ? .black : .white
    }
    
    static var navigationBarTintColor: UIColor {
        return currentTheme == .dark ? .white : .black
    }
    
    static var tintColor: UIColor {
        return currentTheme == .dark ? .white : .black
    }
    
    static var backgroundColor: UIColor {
        return currentTheme == .dark ? .black : .white
    }
    
    static var preferredStatusBarStyle: UIStatusBarStyle {
        return currentTheme == .dark ? .lightContent : .darkContent
    }
    
    static var textFieldPlaceholderTintColor: UIColor {
        return currentTheme == .dark ? UIColor.hexColor("#CACACA") : UIColor.hexColor("#000000")
    }
    
    
    static func applyAppearance(for navigationController: UINavigationController? = nil, withBackgroundColor backgroundColor: UIColor? = nil) {
        
        if #available(iOS 15.0.0, *) {
            
            let barButtonItemAppearance = UIBarButtonItemAppearance()
            barButtonItemAppearance.configureWithDefault(for: .plain)
            barButtonItemAppearance.normal.titleTextAttributes = barButtonTitleTextAttributes
            
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithTransparentBackground()
            navigationBarAppearance.titleTextAttributes = navigationBarTitleTextAttributes
            navigationBarAppearance.backgroundColor = backgroundColor ?? navigationBarBackgroundColor
            navigationBarAppearance.buttonAppearance = barButtonItemAppearance
//            navigationBarAppearance.backgroundEffect = UIBlurEffect(style: .dark)
            
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.tintColor = navigationBarTintColor
            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
            navigationController?.navigationBar.compactAppearance = navigationBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            
//            UINavigationBar.appearance().barTintColor = backgroundColor
//            UINavigationBar.appearance().isTranslucent = true
//            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
//            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
        } else {
            
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().isTranslucent = true
            UINavigationBar.appearance().barTintColor = navigationBarBackgroundColor
            UINavigationBar.appearance().tintColor = tintColor
            UINavigationBar.appearance().titleTextAttributes = navigationBarTitleTextAttributes
        }
    }
}
