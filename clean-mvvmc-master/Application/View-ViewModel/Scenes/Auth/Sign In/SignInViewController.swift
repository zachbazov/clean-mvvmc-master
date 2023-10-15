//
//  SignInViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/09/2023.
//

import UIKit
import CodeBureau

final class SignInViewController: UIViewController, ViewController {
    
    @IBOutlet private weak var emailTextField: TextField!
    
    @IBOutlet private weak var emailTextFieldHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var passwordTextField: TextField!
    
    @IBOutlet private weak var passwordTextFieldHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var signInButton: UIButton!
    
    @IBOutlet private weak var stackViewCenterY: NSLayoutConstraint!
    
    
    var viewModel: SignInViewModel?
    
    
    deinit {
        resignKeyboardEvents()
        
        viewModel = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signKeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.coordinator?.signInViewController = nil
    }
    
    
    @IBAction
    private func backgroundDidTap() {
        view.endEditing(true)
    }
    
    @IBAction
    private func textFieldsDidBeginEditing() {
        updateTextFieldsForEditingEvent()
    }
    
    @IBAction
    private func signInButtonDidTap() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        let user = UserDTO(email: email, password: password)
        let request = HTTPUserDTO.Request(user: user)
        
        viewModel?.signIn(
            with: request,
            completion: { [weak self] user in
                guard let self = self else { return }
                
                guard user != nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    
                    self.viewModel?.coordinator?.signInViewController = nil
                    self.viewModel?.coordinator?.viewController = nil
                    self.viewModel?.coordinator?.navigationController?.removeFromParent()
                    self.viewModel?.coordinator?.navigationController = nil
                    
                    let appCoordinator = Application.app.coordinator
                    let tabBarController = appCoordinator.tabBarCoordinator?.viewController
                    
                    appCoordinator.coordinate(to: tabBarController)
                }
            })
    }
    
    
    @objc
    private func keyboardWillShow() {
        var centerY: CGFloat = -48.0
        
        if UIDevice.current.orientation.isLandscape {
            centerY = calculateTextFieldsStackCenterYForLandspace()
        }
        
        stackViewCenterY.constant = centerY
        
        animateLayoutIfNeeded()
    }
    
    @objc
    private func keyboardWillHide() {
        stackViewCenterY.constant = .zero
        
        animateLayoutIfNeeded()
    }
    
    
    private func signKeyboardEvents() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func resignKeyboardEvents() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func updateTextFieldsForEditingEvent() {
        let textFields: [TextField] = [
            emailTextField,
            passwordTextField]
        
        let heightConstraints: [NSLayoutConstraint] = [
            emailTextFieldHeight,
            passwordTextFieldHeight]
        
        UIView.animate(withDuration: 0.3) {
            
            for (textField, heightConstraint) in zip(textFields, heightConstraints) {
                textField.setHeightConstraint(heightConstraint)
                textField.checkForFirstResponder()
            }
        }
    }
    
    private func calculateTextFieldsStackCenterYForLandspace() -> CGFloat {
        switch true {
        case emailTextField.isFirstResponder:
            return -48.0
        default:
            return -96.0
        }
    }
}
