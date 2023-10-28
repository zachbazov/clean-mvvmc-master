//
//  ProfileCoordinator.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/10/2023.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    
    var navigationController: NavigationController?
    
    var viewController: ProfileViewController?
    
    var addProfileViewController: AddProfileViewController?
    
    weak var editProfileNavigationController: NavigationController?
    
    weak var editProfileViewController: EditProfileViewController?
    
    var editProfileSettingViewController: EditProfileSettingViewController?
    
    var avatarSelectorViewController: AvatarSelectorViewController?
}


extension ProfileCoordinator {
    
    private func createAddProfileViewController() -> AddProfileViewController {
        let viewModel = viewController?.viewModel
        let controller = AddProfileViewController.xib as! AddProfileViewController
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
    
    private func createEditProfileViewController() -> EditProfileViewController {
        let viewModel = viewController?.viewModel
        let navigation = EditProfileViewController.xib as! NavigationController
        let controller = navigation.viewControllers.first as! EditProfileViewController
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        editProfileNavigationController = navigation
        
        return controller
    }
    
    private func createEditProfileSettingViewController() -> EditProfileSettingViewController {
        let viewModel = viewController?.viewModel
        let controller = EditProfileSettingViewController.xib as! EditProfileSettingViewController
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
    
    private func createAvatarSelectorViewController() -> AvatarSelectorViewController {
        let viewModel = viewController?.viewModel
        let controller = AvatarSelectorViewController.xib as! AvatarSelectorViewController
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
}


extension ProfileCoordinator {
    
    enum Screen {
        case add
        case edit
        case editSetting
        case avatarSelector
    }
    
    
    func coordinate(to screen: Screen) {
        
        switch screen {
        case .add:
            
            let controller = createAddProfileViewController()
            
            addProfileViewController = controller
            
            navigationController?.modalPresentationStyle = .pageSheet
            
            if let sheet = controller.sheetPresentationController {
                
                sheet.detents = [.medium(), .large()]
            }
            
            navigationController?.present(controller, animated: true)
            
        case .edit:
            
            let controller = createEditProfileViewController()
            
            editProfileViewController = controller
            
            navigationController?.present(editProfileNavigationController!, animated: true)
            
        case .editSetting:
            
            let controller = createEditProfileSettingViewController()
            
            editProfileSettingViewController = controller
            
            editProfileNavigationController?.pushViewController(controller, animated: true)
            
        case .avatarSelector:
            
            let controller = createAvatarSelectorViewController()
            
            avatarSelectorViewController = controller
            
            if let sheet = controller.sheetPresentationController {

                sheet.detents = [
//                    .custom { _ in
//                        return 200
//                    },
                    .custom { context in
                        return context.maximumDetentValue * 0.33
                    }
                ]
            }
            
            if let editProfileNavigationController = editProfileNavigationController {
                editProfileNavigationController.present(controller, animated: true)
            }
            
            if let addProfileViewController = addProfileViewController {
                addProfileViewController.present(controller, animated: true)
            }
        }
    }
}
