//
//  AuthCoordinator.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/09/2023.
//

import UIKit
import CodeBureau

final class AuthCoordinator: Coordinator {
    
    var navigationController: NavigationController?
    
    var viewController: AuthViewController?
    
    var signInViewController: SignInViewController?
    
    var signUpViewController: SignUpViewController?
}


extension AuthCoordinator {
    
    private func createSignInViewController() -> SignInViewController {
        let viewModel = SignInViewModel()
        let controller = SignInViewController()
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
    
    private func createSignUpViewController() -> SignUpViewController {
        let viewModel = SignUpViewModel()
        let controller = SignUpViewController()
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
}


extension AuthCoordinator {
    
    enum Screen {
        case auth
        case signUp
        case signIn
    }
    
    
    func coordinate(to screen: Screen) {
        switch screen {
        case .auth:
            break
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
