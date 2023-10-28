//
//  SignUpViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/09/2023.
//

import UIKit
import CodeBureau

// MARK: - SignUpViewController Type

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
    
    
    var viewModel: AuthViewModel?
    
    
    private let chainAnimator = ChainAnimator()
    
    
    deinit {
        viewDidDeallocate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidConfigure()
        viewDidBindObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Theme.applyAppearance(for: navigationController, withBackgroundColor: .black)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.coordinator?.signUpViewController = nil
    }
    
    
    func viewDidConfigure() {
        configureNavigationTitleView()
    }
    
    func viewDidBindObservers() {
        signKeyboardEvents()
    }
    
    func viewDidUnbindObservers() {
        resignKeyboardEvents()
    }
    
    func viewDidDeallocate() {
        viewDidUnbindObservers()
        
        viewModel = nil
    }
}

// MARK: - Private Implementation

extension SignUpViewController {
    
    @IBAction
    private func textFieldsDidBeginEditing() {
        updateTextFieldsForEditingEvent()
    }
    
    @IBAction
    private func backgroundDidTap() {
        view.endEditing(true)
    }
    
    @IBAction
    private func signUpButtonDidTap() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let passwordConfirm = passwordConfirmTextField.text else {
            return
        }
        
        let user = UserDTO(name: name, email: email, password: password, passwordConfirm: passwordConfirm)
        let request = HTTPUserDTO.Request(user: user)
        
        sendRequest(request)
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
    
    private func executeChainAnimation() {
        
        let authCoordinator = viewModel?.coordinator
        let appCoordinator = Application.app.coordinator
        let tabBarController = appCoordinator.tabBarCoordinator?.viewController
        
        DispatchQueue.main.async {
            
            self.chainAnimator
                .animate(withDuration: 0.5,
                         delay: .zero,
                         options: .curveEaseInOut,
                         animations: {
                    
                    self.backgroundDidTap()
                })
                .then(duration: 0.5,
                      delay: 1.0,
                      options: .curveEaseInOut,
                      completion: {
                    
                    authCoordinator?.navigationController?.popViewController(animated: true)
                })
                .then(duration: 0.5,
                      delay: 2.0,
                      options: .curveEaseInOut,
                      completion: {
                    
                    authCoordinator?.navigationController?.setNavigationBarHidden(true, animated: true)
                })
                .then(duration: 0.5,
                      delay: 3.0,
                      options: .curveEaseInOut,
                      animations: {
                    
                    authCoordinator?.viewController?.view.transform = CGAffineTransform(translationX: .zero, y: authCoordinator?.viewController?.view.frame.height ?? .zero)
                },
                      completion: {
                    
                    authCoordinator?.viewController = nil
                    authCoordinator?.navigationController = nil
                    
                    appCoordinator.authCoordinator = nil
                    
                    appCoordinator.coordinate(to: tabBarController)
                    
                    tabBarController?.view.transform = CGAffineTransform(translationX: .zero, y: tabBarController?.view.bounds.height ?? .zero)
                })
                .then(duration: 0.5,
                      delay: 4.0,
                      options: .curveEaseInOut,
                      animations: {
                    
                    tabBarController?.view.transform = .identity
                })
        }
    }
    
    private func sendRequest(_ request: HTTPUserDTO.Request) {
        
        if #available(iOS 13.0.0, *) {
            
            Task {
                guard let _ = await viewModel?.signUp(with: request) else {
                    return
                }
                
                executeChainAnimation()
            }
            
        } else {
            
            viewModel?.signUp(
                with: request,
                completion: { [weak self] in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        self.executeChainAnimation()
                    }
                })
        }
    }
}


extension SignUpViewController {
    
    private func configureNavigationTitleView() {
        
        let image = UIImage(named: "netflix-logo-2")
        let imageView = UIImageView(image: image)
        
        navigationItem.titleView = imageView
    }
}
