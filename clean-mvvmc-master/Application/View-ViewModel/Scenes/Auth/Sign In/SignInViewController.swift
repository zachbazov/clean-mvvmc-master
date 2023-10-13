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
    
    
    @objc
    private func keyboardWillShow() {
        let value: CGFloat = -48.0
        var centerY = value
        
        if UIDevice.current.orientation.isLandscape {
            centerY = calculateCenterYConstantForLandspace()
        }
        
        stackViewCenterY.constant = centerY
        
        animateLayoutUpdate()
    }
    
    @objc
    private func keyboardWillHide() {
        stackViewCenterY.constant = .zero
        
        animateLayoutUpdate()
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
                self.updateTextFieldLayout(for: textField, with: heightConstraint)
            }
        }
    }
    
    private func updateTextFieldLayout(for textField: TextField, with heightConstraint: NSLayoutConstraint) {
        
        textField.setHeightConstraint(heightConstraint)
        
        if textField.isFirstResponder {
            textField.textFieldDidBeginEditing()
            
            return
        }
        
        textField.textFieldDidEndEditing()
    }
    
    private func calculateCenterYConstantForLandspace() -> CGFloat {
        switch true {
        case emailTextField.isFirstResponder:
            return -48.0
        default:
            return -96.0
        }
    }
    
    private func animateLayoutUpdate() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
