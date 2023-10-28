//
//  TabBarController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

final class TabBarController: UITabBarController, ViewController {
    
    var viewModel: TabBarViewModel?
}


extension TabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {}
}
