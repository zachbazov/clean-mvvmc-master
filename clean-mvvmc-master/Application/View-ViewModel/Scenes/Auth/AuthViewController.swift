//
//  AuthViewController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/09/2023.
//

import UIKit
import CodeBureau

// MARK: - AuthViewController Type

final class AuthViewController: UIViewController, CoordinatorViewController {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
    @IBOutlet private weak var topGradientView: GradientView!
    
    @IBOutlet private weak var bottomGradientView: GradientView!
    
    @IBOutlet private weak var headerTextView: UITextView!
    
    @IBOutlet private weak var bodyTextView: UITextView!
    
    @IBOutlet private weak var signInButton: UIBarButtonItem!
    
    @IBOutlet private weak var signUpButton: UIButton!
    
    
    var controllerViewModel: AuthViewModel?
    
    
    private let chainAnimator = ChainAnimator()
    
    
    deinit {
        viewDidDeallocate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Theme.applyAppearance(for: navigationController)
        
        executeChainAnimation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        topGradientView.redraw()
        bottomGradientView.redraw()
    }
    
    func viewDidDeallocate() {
        controllerViewModel = nil
    }
}

// MARK: - Private Implementation

extension AuthViewController {
    
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
    
    
    private func executeChainAnimation() {
        
        let offsetY: CGFloat = 64.0
        let scale: CGFloat = 1.2
        
        headerTextView.conceal()
        bodyTextView.conceal()
        topGradientView.conceal()
        bottomGradientView.conceal()
        signInButton.view?.conceal()
        backgroundImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        signUpButton.transform = CGAffineTransform(translationX: .zero, y: offsetY)
        headerTextView.transform = CGAffineTransform(scaleX: scale, y: scale)
        navigationController?.navigationBar.transform = CGAffineTransform(translationX: .zero, y: -offsetY)
        
        chainAnimator
            .animate(withDuration: 1.5,
                     delay: 0.25,
                     options: .curveEaseInOut,
                     animations: {
                
                self.backgroundImageView.transform = .identity
            })
            .then(duration: 0.5,
                  delay: 0.5,
                  options: .curveEaseInOut,
                  animations: {
                
                self.headerTextView.reveal()
                
                self.topGradientView.reveal()
                self.bottomGradientView.reveal()
                
                self.signUpButton.transform = .identity
                
                self.navigationController?.navigationBar.transform = .identity
            })
            .then(duration: 0.5,
                  delay: 0.75,
                  options: .curveEaseInOut,
                  animations: {
                
                self.headerTextView.transform = .identity
            })
            .then(duration: 0.5,
                  delay: 1.0,
                  options: .curveEaseInOut,
                  animations: {
                
                self.bodyTextView.reveal()
            })
            .then(duration: 0.5,
                  delay: 1.25,
                  options: .curveEaseInOut,
                  animations: {
                
              self.signInButton.view?.reveal()
            })
    }
}
