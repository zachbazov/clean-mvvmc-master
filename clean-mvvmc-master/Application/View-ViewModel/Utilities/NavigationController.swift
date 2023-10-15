//
//  NavigationController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 28/09/2023.
//

import UIKit

class NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.preferredStatusBarStyle
    }
}
