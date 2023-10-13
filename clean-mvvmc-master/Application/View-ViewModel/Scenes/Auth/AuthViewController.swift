//
//  AuthViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/09/2023.
//

import UIKit
import CodeBureau

final class AuthViewController: UIViewController, CoordinatorViewController {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
    @IBOutlet private weak var topGradientView: GradientView!
    
    @IBOutlet private weak var bottomGradientView: GradientView!
    
    @IBOutlet private weak var headerTextView: UITextView!
    
    @IBOutlet private weak var bodyTextView: UITextView!
    
    @IBOutlet private weak var signInButton: UIBarButtonItem!
    
    @IBOutlet private weak var signUpButton: UIButton!
    
    
    var controllerViewModel: AuthViewModel?
    
    
    private var animator = ViewAnimator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Theme.applyAppearance(for: navigationController)
        
        configureViewAnimator()
        animator.execute()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        topGradientView.redraw()
        bottomGradientView.redraw()
    }
    
    
    @IBAction
    private func buttonDidTap(_ sender: AnyObject) {
        switch sender.tag {
        case 0:
            controllerViewModel?.coordinator?.coordinate(to: .signUp)
        case 1:
            controllerViewModel?.coordinator?.coordinate(to: .signIn)
        default:
            break
        }
    }
    
    
    private func configureViewAnimator() {
        animator.preparations = { [weak self] in
            guard let self = self else { return }
            
            let offsetY: CGFloat = 64.0
            let scale: CGFloat = 1.2
            
            self.headerTextView.conceal()
            self.bodyTextView.conceal()
            self.topGradientView.conceal()
            self.bottomGradientView.conceal()
            self.signInButton.view?.conceal()
            self.backgroundImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.signUpButton.transform = CGAffineTransform(translationX: .zero, y: offsetY)
            self.headerTextView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: .zero, y: -offsetY)
        }
        
        animator.operations = { [weak self] in
            guard let self = self else { return }
            
            let firstAnimationDuration: TimeInterval = 1.5
            let secondAnimationDuration: TimeInterval = 0.5
            
            let firstAnimationDelay: TimeInterval = 0.25
            let secondAnimationDelay: TimeInterval = .zero
            let thirdAnimationDelay: TimeInterval = 0.5
            let fourthAnimationDelay: TimeInterval = 0.5
            let fifthAnimationDelay: TimeInterval = 0.5
            
            let options: UIView.AnimationOptions = [.curveEaseInOut]
            
            animator
                .animate(withDuration: firstAnimationDuration,
                         delay: firstAnimationDelay,
                         options: options) {
                    
                    self.backgroundImageView.transform = .identity
                    
                }.then(duration: secondAnimationDuration,
                       delay: secondAnimationDelay,
                       options: options) {
                    
                    self.headerTextView.reveal()
                    
                    self.topGradientView.reveal()
                    self.bottomGradientView.reveal()
                    
                    self.signUpButton.transform = .identity
                    
                    self.navigationController?.navigationBar.transform = .identity
                    
                }.then(duration: secondAnimationDuration,
                       delay: thirdAnimationDelay,
                       options: options) {
                    
                    self.headerTextView.transform = .identity
                    
                }.then(duration: secondAnimationDuration,
                       delay: fourthAnimationDelay,
                       options: options) {
                    
                    self.bodyTextView.reveal()
                    
                }.then(duration: secondAnimationDuration,
                       delay: fifthAnimationDelay,
                       options: options) {
                    
                    self.signInButton.view?.reveal()
                }
        }
    }
}
