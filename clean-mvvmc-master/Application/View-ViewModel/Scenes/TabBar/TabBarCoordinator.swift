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
    
    var homeViewController: HomeViewController?
    
    var newsViewController: NewsViewController?
    
    var myNetflixViewController: MyNetflixViewController?
    
    var detailViewController: DetailViewController?
    
//    var searchNavigationController: UINavigationController?
//    var searchViewController: SearchViewController?
}


extension TabBarCoordinator {
    
    // MARK: Dependencies
    
    private func createHomeViewController() -> HomeViewController? {
        let navigation = viewController?.viewControllers?.first as? UINavigationController
        let controller = navigation?.viewControllers.first as? HomeViewController
        let viewModel = HomeViewModel()
        
        controller?.viewModel = viewModel
        controller?.viewModel?.coordinator = self
        
        return controller
    }
    
    private func createNewsViewController() -> NewsViewController? {
        let controller = viewController?.viewControllers?[1] as? NewsViewController
        let viewModel = NewsViewModel()
        
        controller?.viewModel = viewModel
        controller?.viewModel?.coordinator = self
        
        return controller
    }
    
    private func createMyNetflixViewController() -> MyNetflixViewController? {
        let controller = viewController?.viewControllers?.last as? MyNetflixViewController
        let viewModel = MyNetflixViewModel()
        
        controller?.viewModel = viewModel
        controller?.viewModel?.coordinator = self
        
        return controller
    }
    
    // MARK: External Scene Dependencies
    
    func createDetailViewController() -> DetailViewController? {
        let controller = DetailViewController.xib as! DetailViewController
        let viewModel = DetailViewModel()
        
        controller.viewModel = viewModel
        controller.viewModel?.coordinator = self
        
        return controller
    }
    
//    func createSearchViewController() -> UINavigationController {
//        let controller = SearchViewController()
//        let navigation = UINavigationController(rootViewController: controller)
//        
//        return navigation
//    }
}


extension TabBarCoordinator {
    
    func assignChildViewControllers() {
        homeViewController = createHomeViewController()
        newsViewController = createNewsViewController()
        myNetflixViewController = createMyNetflixViewController()
    }
}


extension TabBarCoordinator {
    
    enum Screen: Int {
        case detail
//        case search
    }
    
    
    func coordinate(to screen: Screen) {
        
        switch screen {
            
        case .detail:
            
            guard let controller = createDetailViewController() else { return }
            
            detailViewController = controller
            
            viewController?.present(controller, animated: true)
            
//        case .search:
//            
//            searchNavigationController = createSearchViewController()
//            searchViewController = searchNavigationController?.viewControllers.first as? SearchViewController
//            
//            guard let navigation = searchNavigationController,
//                  let container = viewController?.view else {
//                return
//            }
//            
//            viewController?.add(navigation, in: container)
        }
    }
}






extension UIViewController {
    
    func add(_ childController: UIViewController, in container: UIView) {
        
        addChild(childController)
        
        container.addSubview(childController.view)
        
        childController.didMove(toParent: self)
    }
    
    func removeChild() {
        
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        
        removeFromParent()
        
        view.removeFromSuperview()
    }
}


final class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }
}
