//
//  RootCoordinator.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

final class RootCoordinator {
    
    weak var window: UIWindow? {
        didSet {
            coordinate(to: tabBarCoordinator?.viewController)
        }
    }
    
    lazy var tabBarCoordinator: TabBarCoordinator? = createTabBarCoordinator()
}


extension RootCoordinator {
    
    private func createTabBarCoordinator() -> TabBarCoordinator {
        let coordinator = TabBarCoordinator()
        let viewModel = TabBarViewModel()
        let controller = TabBarController.xib as! TabBarController
        
        controller.controllerViewModel = viewModel
        controller.controllerViewModel?.coordinator = coordinator
        coordinator.viewController = controller
        
        return coordinator
    }
}


extension RootCoordinator {
    
    private func coordinate(to viewController: UIViewController?) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
