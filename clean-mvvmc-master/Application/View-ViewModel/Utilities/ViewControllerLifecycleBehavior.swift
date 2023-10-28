//
//  ViewControllerLifecycleBehavior.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/10/2023.
//

import Foundation

// MARK: - ViewControllerObservingBehavior Type

@objc
protocol ViewControllerObservingBehavior {
    
    @objc optional func viewDidBindObservers()
    @objc optional func viewDidUnbindObservers()
}

// MARK: - ViewControllerLifecycleBehavior Type

@objc
protocol ViewControllerLifecycleBehavior: ViewControllerObservingBehavior {
    
    @objc optional func viewDidDeploySubviews()
    @objc optional func viewHierarchyDidConfigure()
    @objc optional func viewDidConfigure()
    @objc optional func viewDidTargetSubviews()
    @objc optional func viewDidDeallocate()
}
