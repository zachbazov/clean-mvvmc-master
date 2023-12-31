//
//  AuthCoordinator.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/09/2023.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    var navigationController: NavigationController?
    
    var viewController: AuthViewController?
    
    var signInViewController: SignInViewController?
    
    var signUpViewController: SignUpViewController?
    
    var profileViewController: ProfileViewController?
}


extension AuthCoordinator {
    
    private func createSignInViewController() -> SignInViewController {
        let viewModel = viewController?.viewModel
        let controller = SignInViewController.xib as! SignInViewController
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
    
    private func createSignUpViewController() -> SignUpViewController {
        let viewModel = viewController?.viewModel
        let controller = SignUpViewController.xib as! SignUpViewController
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
}


extension AuthCoordinator {
    
    enum Screen {
        case signUp
        case signIn
    }
    
    
    func coordinate(to screen: Screen) {
        
        switch screen {
        case .signUp:
            let controller = createSignUpViewController()
            
            signUpViewController = controller
            
            navigationController?.pushViewController(controller, animated: true)
            
        case .signIn:
            let controller = createSignInViewController()
            
            signInViewController = controller
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
