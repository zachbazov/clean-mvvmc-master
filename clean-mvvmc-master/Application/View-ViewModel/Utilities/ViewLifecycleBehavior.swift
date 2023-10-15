//
//  ViewLifecycleBehavior.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import UIKit

// MARK: - ViewLifecycleBehavior Type

@objc
protocol ViewLifecycleBehavior {
    @objc optional func deploySubviews()
    @objc optional func configureHierarchy()
    @objc optional func configureSubviews()
    @objc optional func targetSubviews()
}

// MARK: - ViewLifecycleBehavior Implementation

extension UIView: ViewLifecycleBehavior {
}
