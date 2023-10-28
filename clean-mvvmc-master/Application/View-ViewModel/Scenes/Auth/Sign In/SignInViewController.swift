//
//  SignInViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/09/2023.
//

import UIKit
import CodeBureau

// MARK: - SignInViewController Type

final class SignInViewController: UIViewController, ViewController {
    
    @IBOutlet private weak var emailTextField: TextField!
    
    @IBOutlet private weak var emailTextFieldHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var passwordTextField: TextField!
    
    @IBOutlet private weak var passwordTextFieldHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var signInButton: UIButton!
    
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
        
        viewModel?.coordinator?.signInViewController = nil
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

extension SignInViewController {
    
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
        
        sendRequest(request)
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
                guard let _ = await viewModel?.signIn(with: request) else {
                    return
                }
                
                executeChainAnimation()
            }
            
        } else {
            
            viewModel?.signIn(
                with: request,
                completion: { [weak self] response in
                    
                    guard let self = self,
                          let _ = response.data else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.executeChainAnimation()
                    }
                })
        }
    }
}


extension SignInViewController {
    
    private func configureNavigationTitleView() {
        
        let image = UIImage(named: "netflix-logo-2")
        let imageView = UIImageView(image: image)
        
        navigationItem.titleView = imageView
    }
}
