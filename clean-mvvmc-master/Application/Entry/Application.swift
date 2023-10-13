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
    
    var server = MongoServer(host: MongoHostProvider())
    
    private(set) lazy var coordinator = AppCoordinator()
    
    
    private init() {}
}


extension Application {
    
    func appDidLaunch(in window: UIWindow?) {
        coordinator.window = window
        
        server.delegate = self
    }
}


extension Application: MongoServerDelegate {
    
    func serverDidLaunch(_ server: MongoServer) {
        self.server(server, reauthenticeUserFromStore: UserResponseStore())
    }
    
    func server(_ server: MongoServer, reauthenticeUserFromStore store: UserResponseStore) {
        store.fetcher.fetch { [weak self] result in
            guard let self = self else { return }
            
            self.handleFetchResponse(for: result)
        }
    }
}


extension Application {
    
    private func handleFetchResponse(for result: Result<HTTPUserDTO.Response?, CoreDataStoreError>) {
        switch result {
        case .success(let response):
            if let response = response,
               let user = response.data {
                return authenticate(user)
            }
            
            coordinateToAuthScene()
        case .failure(let error):
            debugPrint(.error, "\(error)")
        }
    }
    
    private func authenticate(_ user: UserDTO) {
        let request = HTTPUserDTO.Request(user: user)
        
        server.authenticator.signIn(
            request,
            error: nil,
            cached: { _ in
                self.coordinateToTabBarScene()
            },
            completion: nil)
    }
    
    private func coordinateToTabBarScene() {
        let tabBarCoordinator = coordinator.tabBarCoordinator
        
        coordinator.coordinate(to: tabBarCoordinator?.viewController)
    }
    
    private func coordinateToAuthScene() {
        let authCoordinator = coordinator.authCoordinator
        
        coordinator.coordinate(to: authCoordinator?.navigationController)
    }
}
