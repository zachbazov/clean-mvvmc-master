//
//  ProfileCoordinator.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/10/2023.
//

import Foundation
import CodeBureau

final class ProfileCoordinator: Coordinator {
    
    var navigationController: NavigationController?
    
    var viewController: ProfileViewController?
    
    var addProfileViewController: AddProfileViewController?
    
    var editProfileViewController: EditProfileViewController?
}


extension ProfileCoordinator {
    
    private func createAddProfileViewController() -> AddProfileViewController {
        let viewModel = AddProfileViewModel()
        let controller = AddProfileViewController.xib as! AddProfileViewController
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
    
    private func createEditProfileViewController() -> EditProfileViewController {
        let viewModel = EditProfileViewModel()
        let controller = EditProfileViewController.xib as! EditProfileViewController
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
}


extension ProfileCoordinator {
    
    enum Screen {
        case add
        case edit
    }
    
    
    func coordinate(to screen: Screen) {
        switch screen {
        case .add:
            let controller = createAddProfileViewController()
            
            addProfileViewController = controller
            
            navigationController?.pushViewController(controller, animated: true)
            
        case .edit:
            let controller = createEditProfileViewController()
            
            editProfileViewController = controller
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
