//
//  Application.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit

final class Application {
    
    static let app = Application()
    
    private(set) lazy var coordinator = AppCoordinator()
    
    
    private init() {}
}


extension Application {
    
    func appDidLaunch(in window: UIWindow?) {
        coordinator.window = window
    }
}
