//
//  TabBarController.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit
import CodeBureau

final class TabBarController: UITabBarController, ViewController {
    
    var viewModel: TabBarViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidBindObservers()
        
        viewModel.fetchSelectedProfile()
    }
    
    
    func viewDidBindObservers() {
        
        viewModel.profile.observe(on: self) { [weak self] profile in
            guard let self = self,
                  let profile = profile else {
                return
            }
            
            self.updateTabBarItem(for: profile)
        }
    }
    
    func viewDidUnbindObservers() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.profile.remove(observer: self)
        
        debugPrint(.success, "Removed `\(Self.self)` observers.")
    }
    
    func viewDidDeallocate() {
        viewDidUnbindObservers()
    }
    
    
    func updateTabBarItem(for profile: Profile) {
        let originImage = UIImage(named: profile.image)
        let sizedImage = originImage?.scale(newWidth: 20.0, cornerRadius: 2.0, borderWidth: 3.0)
        let item = tabBar.items?.last
        
        item?.selectedImage = sizedImage?.withRenderingMode(.alwaysOriginal)
        item?.image = sizedImage?.withRenderingMode(.alwaysOriginal)
    }
}


extension TabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didBeginCustomizing items: [UITabBarItem]) {
        print("didBeginCustomizing")
    }
    
    override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
        print("willBeginCustomizing")
    }
    
    override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        print("didEndCustomizing")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, willBeginCustomizing viewControllers: [UIViewController]) {
        print("willBeginCustomizing2")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, willEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        print("willEndCustomizing2")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        print("didEndCustomizing2")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("didselect")
    }
}
