//
//  EditProfileViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/10/2023.
//

import UIKit

final class EditProfileViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private(set) weak var avatarButton: UIButton!
    
    @IBOutlet private weak var badgeViewContainer: UIView!
    
    @IBOutlet private weak var nameTextField: TextField!
    
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
    
    
    var viewModel: ProfileViewModel?
    
    private var editBadge: BadgeView?
    
    private var dataSource: ProfileSettingsTableViewDataSource?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidDeploySubviews()
        viewDidConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutTableView()
    }
    
    
    func viewDidDeploySubviews() {
        createBadgeView()
        createDataSource()
    }
    
    func viewDidConfigure() {
        configureButton()
        configureTextField()
    }
}


extension EditProfileViewController {
    
    @IBAction
    private func cancelDidTap() {
        dismiss(animated: true)
    }
    
    @IBAction
    private func doneDidTap() {
        
        dismiss(animated: true)
        
        if viewModel?.hasChanges ?? false {
            
            guard let updatedProfile = viewModel?.editingProfile else {
                return
            }
            
            if let index = viewModel?.profiles.value.firstIndex(where: { $0._id == updatedProfile._id ?? "" }) as? Int {
                
                viewModel?.profiles.value[index] = updatedProfile
                
                viewModel?.coordinator?.viewController?.editBarButtonDidTap()
            }
            
            let authService = Application.app.server.authService
            
            guard let user = authService.user else {
                return
            }
            
            let request = HTTPProfileDTO.PATCH.Request(user: user.toDTO(),
                                                       id: updatedProfile._id ?? "",
                                                       profile: updatedProfile.toDTO())
            
            let settingsRequest = HTTPProfileDTO.Settings.PATCH.Request(user: user.toDTO(),
                                                                        id: updatedProfile.settings?._id ?? "",
                                                                        settings: updatedProfile.toDTO().settings ?? .defaultValue)
            
            viewModel?.updateProfile(request: request, with: settingsRequest)
        }
    }
    
    @IBAction
    private func backgroundDidTap() {
        view.endEditing(true)
    }
}


extension EditProfileViewController {
    
    private func layoutTableView() {
        
        let lineSpacing: CGFloat = 4.0
        let cellHeight: CGFloat = 64.0
        let numberOfSettings = viewModel?.settings.count.toCGFloat() ?? .zero
        
        tableViewHeight.constant = (cellHeight + lineSpacing) * numberOfSettings
    }
    
    private func createBadgeView() {
        
        editBadge = BadgeView(type: .edit)
            .addToHierarchy(in: badgeViewContainer)
            .constraint(to: badgeViewContainer)
        
        editBadge?.delegate = self
    }
    
    private func createDataSource() {
        
        dataSource = ProfileSettingsTableViewDataSource(tableView, with: viewModel)
        
        dataSource?.dataSourceDidChange()
    }
    
    private func configureButton() {
        
        avatarButton.layer.cornerRadius = 8.0
        
        let imageName = viewModel?.editingProfile?.image ?? ""
        let image = UIImage(named: imageName)?
            .withRenderingMode(.alwaysOriginal)
        
        avatarButton.setImage(image, for: .normal)
    }
    
    private func configureTextField() {
        
        nameTextField.delegate = self
        nameTextField.text = viewModel?.editingProfile?.name ?? ""
        
        nameTextField.checkForFirstResponder()
    }
}


extension EditProfileViewController: BadgeViewDelegate {
    
    func badgeDidTap(_ badge: BadgeView) {
        
        viewModel?.coordinator?.viewController?.viewModel?.addingAvatar = nil
        
        viewModel?.coordinator?.addProfileViewController = nil
        
        viewModel?.coordinator?.coordinate(to: .avatarSelector)
    }
}


extension EditProfileViewController: UITextFieldDelegate {
    
    @IBAction
    private func textFieldDidChange(_ textField: TextField) {
        viewModel?.editingProfile?.name = textField.text ?? ""
    }
}
