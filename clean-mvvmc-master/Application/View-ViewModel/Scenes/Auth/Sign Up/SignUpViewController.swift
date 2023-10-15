//
//  SignUpViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/09/2023.
//

import UIKit
import CodeBureau

final class SignUpViewController: UIViewController, ViewController {
    
    @IBOutlet private weak var nameTextField: TextField!
    
    @IBOutlet private weak var nameTextFieldHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var emailTextField: TextField!
    
    @IBOutlet private weak var emailTextFieldHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var passwordTextField: TextField!
    
    @IBOutlet private weak var passwordTextFieldHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var passwordConfirmTextField: TextField!
    
    @IBOutlet private weak var passwordConfirmTextFieldHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var stackViewCenterY: NSLayoutConstraint!
    
    
    var viewModel: SignUpViewModel?
    
    
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
        
        viewModel?.coordinator?.signUpViewController = nil
    }
    
    
    @IBAction
    private func textFieldsDidBeginEditing() {
        updateTextFieldsForEditingEvent()
    }
    
    @IBAction
    private func backgroundDidTap() {
        view.endEditing(true)
    }
    
    
    @objc
    private func keyboardWillShow() {
        var centerY: CGFloat = -40.0
        
        if UIDevice.current.orientation.isLandscape {
            centerY = calculateCenterYConstantForLandspace()
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
            nameTextField,
            emailTextField,
            passwordTextField,
            passwordConfirmTextField]
        
        let heightConstraints: [NSLayoutConstraint] = [
            nameTextFieldHeight,
            emailTextFieldHeight,
            passwordTextFieldHeight,
            passwordConfirmTextFieldHeight]
        
        UIView.animate(withDuration: 0.3) {
            
            for (textField, heightConstraint) in zip(textFields, heightConstraints) {
                textField.setHeightConstraint(heightConstraint)
                textField.checkForFirstResponder()
            }
        }
    }
    
    private func calculateCenterYConstantForLandspace() -> CGFloat {
        switch true {
        case nameTextField.isFirstResponder:
            return -40.0
        case emailTextField.isFirstResponder:
            return -80.0
        case passwordTextField.isFirstResponder:
            return -120.0
        default:
            return -160.0
        }
    }
}
