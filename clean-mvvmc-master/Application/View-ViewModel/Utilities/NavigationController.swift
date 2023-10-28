//
//  NavigationController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 28/09/2023.
//

import UIKit

class NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.preferredStatusBarStyle
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        delegate = self
    }
}


extension NavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            
            switch (fromVC, toVC) {
                
            case (is EditProfileViewController, is EditProfileSettingViewController):
                return HorizontalPushAnimationController()
                
            default:
                return nil
            }
            
        case .pop:
            
            switch (fromVC, toVC) {
                
            case (is EditProfileSettingViewController, is EditProfileViewController):
                return HorizontalPopAnimationController()
                
            default:
                return nil
            }
            
        default:
            return nil
        }
        
    }
}

class HorizontalPushAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let fromView = fromVC.view,
              let toView = toVC.view else {
            
            return transitionContext.completeTransition(false)
        }
        
        transitionContext.containerView.addSubview(toView)
        
        toView.frame = CGRect(x: toView.frame.width, y: fromVC.navigationController?.navigationBar.bounds.height ?? .zero, width: toView.frame.width, height: toView.frame.height)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            
            toView.frame = transitionContext.finalFrame(for: toVC)
            fromView.frame = CGRect(x: -fromView.frame.width, y: fromVC.navigationController?.navigationBar.bounds.height ?? .zero, width: fromView.frame.width, height: fromView.frame.height)
            
        } completion: { _ in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


class VerticalPushAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let fromView = fromVC.view,
              let toView = toVC.view else {
            
            return transitionContext.completeTransition(false)
        }
        
        transitionContext.containerView.addSubview(toView)
        
        toView.frame = CGRect(x: .zero, y: toView.frame.height, width: toView.frame.width, height: toView.frame.height)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            
            toView.frame = transitionContext.finalFrame(for: toVC)
            fromView.frame = CGRect(x: .zero, y: -fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
            
        } completion: { _ in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


class HorizontalPopAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let fromView = fromVC.view,
              let toView = toVC.view else {
            transitionContext.completeTransition(false)
            return
        }

        transitionContext.containerView.addSubview(toView)
        transitionContext.containerView.sendSubviewToBack(toView)

        toView.frame = CGRect(x: -toView.frame.width, y: fromVC.navigationController?.navigationBar.bounds.height ?? .zero, width: toView.frame.width, height: toView.frame.height)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            toView.frame = transitionContext.finalFrame(for: toVC)
            
            fromView.frame = CGRect(x: toView.frame.width, y: fromVC.navigationController?.navigationBar.bounds.height ?? .zero, width: fromView.frame.width, height: fromView.frame.height)
            
        }) { _ in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


class VerticalPopAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let fromView = fromVC.view,
              let toView = toVC.view else {
            transitionContext.completeTransition(false)
            return
        }

        transitionContext.containerView.addSubview(toView)
        transitionContext.containerView.sendSubviewToBack(toView)

        toView.frame = CGRect(x: .zero, y: -toView.frame.height, width: toView.frame.width, height: toView.frame.height)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            toView.frame = transitionContext.finalFrame(for: toVC)
            
            fromView.frame = CGRect(x: .zero, y: toView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
            
        }) { _ in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
