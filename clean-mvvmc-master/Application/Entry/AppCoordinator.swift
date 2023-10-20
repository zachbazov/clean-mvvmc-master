//
//  AppCoordinator.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

final class AppCoordinator {
    
    weak var window: UIWindow?
    
    
    lazy var tabBarCoordinator: TabBarCoordinator? = createTabBarCoordinator()
    
    lazy var authCoordinator: AuthCoordinator? = createAuthCoordinator()
    
    lazy var profileCoordinator: ProfileCoordinator? = createProfileCoordinator()
}


extension AppCoordinator {
    
    private func createTabBarCoordinator() -> TabBarCoordinator {
        let coordinator = TabBarCoordinator()
        let viewModel = TabBarViewModel()
        let controller = TabBarController.xib as! TabBarController
        
        controller.controllerViewModel = viewModel
        controller.controllerViewModel?.coordinator = coordinator
        coordinator.viewController = controller
        
        return coordinator
    }
    
    private func createAuthCoordinator() -> AuthCoordinator {
        let coordinator = AuthCoordinator()
        let viewModel = AuthViewModel()
        let navigation = AuthViewController.xib as! NavigationController
        let controller = navigation.viewControllers.first as! AuthViewController
        
        controller.controllerViewModel = viewModel
        controller.controllerViewModel?.coordinator = coordinator
        coordinator.viewController = controller
        coordinator.navigationController = navigation
        
        return coordinator
    }
    
    private func createProfileCoordinator() -> ProfileCoordinator {
        let coordinator = ProfileCoordinator()
        let viewModel = ProfileViewModel()
        let navigation = ProfileViewController.xib as! NavigationController
        let controller = navigation.viewControllers.first as! ProfileViewController
        
        controller.controllerViewModel = viewModel
        controller.controllerViewModel?.coordinator = coordinator
        coordinator.viewController = controller
        coordinator.navigationController = navigation
        
        return coordinator
    }
}


extension AppCoordinator {
    
    func coordinate(to viewController: UIViewController?) {
        window?.rootViewController = viewController
    }
}
