//
//  TabBarController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit
import CodeBureau

final class TabBarController: UITabBarController, CoordinatorViewController {
    
    var controllerViewModel: TabBarViewModel?
}


extension TabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {}
}
