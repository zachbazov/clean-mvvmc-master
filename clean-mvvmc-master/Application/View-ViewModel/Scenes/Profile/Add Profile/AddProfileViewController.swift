//
//  AddProfileViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/10/2023.
//

import UIKit

final class AddProfileViewController: UIViewController, ViewController {
    
    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet private(set) weak var avatarButton: UIButton!
    
    @IBOutlet private weak var badgeViewContainer: UIView!
    
    @IBOutlet private weak var nameTextField: TextField!
    
    @IBOutlet private weak var kidsProfileSwitch: UISwitch!
    
    
    var viewModel: ProfileViewModel?
    
    private var editBadge: BadgeView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidDeploySubviews()
        viewDidConfigure()
    }
    
    
    func viewDidDeploySubviews() {
        createBadgeView()
    }
    
    func viewDidConfigure() {
        configureButton()
    }
}


extension AddProfileViewController {
    
    @IBAction
    private func backgroundDidTap() {
        view.endEditing(true)
    }
    
    
    private func createBadgeView() {
        
        editBadge = BadgeView(type: .edit)
            .addToHierarchy(in: badgeViewContainer)
            .constraint(to: badgeViewContainer)
        
        editBadge?.delegate = self
    }
    
    private func configureButton() {
        
        avatarButton.layer.cornerRadius = 8.0
        
        let asset = viewModel?.avatars.randomElement() ?? ""
        let image = UIImage(named: asset)?
            .withRenderingMode(.alwaysOriginal)
        
        avatarButton.setImage(image, for: .normal)
        
        viewModel?.addingAvatar = asset.toAvatar()
    }
}


extension AddProfileViewController: BadgeViewDelegate {
    
    func badgeDidTap(_ badge: BadgeView) {
        
        viewModel?.coordinator?.viewController?.viewModel?.editingProfile = nil
        
        viewModel?.coordinator?.editProfileViewController = nil
        viewModel?.coordinator?.editProfileNavigationController = nil
        
        viewModel?.coordinator?.coordinate(to: .avatarSelector)
    }
}


extension AddProfileViewController {
    
    @IBAction
    private func cancelDidTap() {
        dismiss(animated: true)
    }
    
    @IBAction
    private func saveDidTap() {
        
        let authService = Application.app.server.authService
        
        guard var user = authService.user else {
            return
        }
        
        let profile = ProfileDTO(name: nameTextField.text ?? "", image: viewModel?.addingAvatar?.image ?? "", active: false, user: user._id ?? "", settings: nil)
        
        let request = HTTPProfileDTO.POST.Request(user: user.toDTO(), profile: profile)
        
        viewModel?.createProfile(with: request)
        
        dismiss(animated: true)
    }
    
    @IBAction
    private func textFieldValueDidChange(_ textField: TextField) {
        saveBarButton.isEnabled = !(textField.text?.isEmpty ?? false) ? true : false
    }
}
