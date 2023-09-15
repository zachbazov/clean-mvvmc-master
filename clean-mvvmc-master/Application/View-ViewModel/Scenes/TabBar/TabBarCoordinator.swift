//
//  TabBarCoordinator.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    weak var viewController: TabBarController? {
        didSet {
            assignChildViewControllers()
        }
    }
    
    var alphaViewController: AlphaViewController?
    
    var betaViewController: BetaViewController?
    
    var gammaViewController: GammaViewController?
    
    var deltaViewController: DeltaViewController?
    
    var omegaViewController: OmegaViewController?
}


extension TabBarCoordinator {
    
    // MARK: Dependencies
    
    private func createAlphaViewController() -> AlphaViewController? {
        let navigation = viewController?.viewControllers?.first as? UINavigationController
        let controller = navigation?.viewControllers.first as? AlphaViewController
        let viewModel = AlphaViewModel()
        
        controller?.viewModel = viewModel
        controller?.viewModel?.coordinator = self
        
        return controller
    }
    
    private func createBetaViewController() -> BetaViewController? {
        let controller = viewController?.viewControllers?[1] as? BetaViewController
        let viewModel = BetaViewModel()
        
        controller?.viewModel = viewModel
        controller?.viewModel?.coordinator = self
        
        return controller
    }
    
    private func createGammaViewController() -> GammaViewController? {
        let controller = viewController?.viewControllers?.last as? GammaViewController
        let viewModel = GammaViewModel()
        
        controller?.viewModel = viewModel
        controller?.viewModel?.coordinator = self
        
        return controller
    }
    
    // MARK: External Scene Dependencies
    
    func createDeltaViewController() -> DeltaViewController? {
        let controller = DeltaViewController.xib as! DeltaViewController
        let viewModel = DeltaViewModel()
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
    
    func createOmegaViewController() -> OmegaViewController? {
        let controller = OmegaViewController.xib as! OmegaViewController
        let viewModel = OmegaViewModel()
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
}


extension TabBarCoordinator {
    
    func assignChildViewControllers() {
        alphaViewController = createAlphaViewController()
        betaViewController = createBetaViewController()
        gammaViewController = createGammaViewController()
    }
}


extension TabBarCoordinator {
    
    enum Screen: Int {
        case detail
        case search
    }
    
    
    func coordinate(to screen: Screen) {
        switch screen {
        case .detail:
            guard let controller = createDeltaViewController() else { return }
            
            deltaViewController = controller
            
            viewController?.present(controller, animated: true)
        case .search:
            guard let controller = createOmegaViewController() else { return }
            
            omegaViewController = controller
            
            alphaViewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
