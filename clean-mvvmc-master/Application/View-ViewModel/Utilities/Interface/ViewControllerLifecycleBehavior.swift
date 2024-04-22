//
//  ViewControllerLifecycleBehavior.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/10/2023.
//

import UIKit

// MARK: - ViewControllerObservingBehavior Type

@objc
protocol ViewControllerObservingBehavior {
    @objc optional func viewDidBindObservers()
    @objc optional func viewDidUnbindObservers()
}

// MARK: - ViewControllerLifecycleBehavior Type

//@objc
//protocol ViewControllerLifecycleBehavior: ViewControllerObservingBehavior {
//    @objc optional func viewDidDeploySubviews()
//    @objc optional func viewHierarchyDidConfigure()
//    @objc optional func viewDidConfigure()
//    @objc optional func viewDidTargetSubviews()
//    @objc optional func viewDidDeallocate()
//    
//    func viewDidLoad(viewController: UIViewController)
//    func viewWillAppear(viewController: UIViewController)
//    func viewDidAppear(viewController: UIViewController)
//    func viewWillDisappear(viewController: UIViewController)
//    func viewDidDisappear(viewController: UIViewController)
//    func viewWillLayoutSubviews(viewController: UIViewController)
//    func viewDidLayoutSubviews(viewController: UIViewController)
//}
//
//extension ViewControllerLifecycleBehavior {
//    func viewDidDeploySubviews() {}
//    func viewHierarchyDidConfigure() {}
//    func viewDidConfigure() {}
//    func viewDidTargetSubviews() {}
//    func viewDidDeallocate() {}
//    
//    func viewDidLoad(viewController: UIViewController) {}
//    func viewWillAppear(viewController: UIViewController) {}
//    func viewDidAppear(viewController: UIViewController) {}
//    func viewWillDisappear(viewController: UIViewController) {}
//    func viewDidDisappear(viewController: UIViewController) {}
//    func viewWillLayoutSubviews(viewController: UIViewController) {}
//    func viewDidLayoutSubviews(viewController: UIViewController) {}
//}
//
