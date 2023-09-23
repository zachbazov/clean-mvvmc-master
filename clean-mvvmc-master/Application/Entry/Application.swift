//
//  Application.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/09/2023.
//

import UIKit
import CodeBureau

final class Application {
    
    static let app = Application()
    
    private(set) lazy var coordinator = AppCoordinator()
    
    
    private init() {}
}


extension Application {
    
    func appDidLaunch(in window: UIWindow?) {
        coordinator.window = window
        
        resignSession()
    }
    
    
    private func resignSession() {
        let authService = MongoService.shared.authService
        
        let user = UserDTO(email: "qwe@gmail.com", password: "qweqweqwe")
        let request = HTTPUserDTO.Request(user: user)
        
        authService.signIn(
            request,
            error: { response in
                debugPrint(.debug, "Error \(response)")
            },
            cached: { response in
                debugPrint(.debug, "Cached \(response)")
            },
            completion: { response in
                if let response = response {
                    debugPrint(.debug, "Completion \(response)")
                }
            })
    }
}
