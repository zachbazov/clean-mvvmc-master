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
    
    
    private init() {
    }
    
    
    var server = Server()
    
    private(set) lazy var coordinator = AppCoordinator()
}


extension Application {
    
    func appDidLaunch(in window: UIWindow?) {
        coordinator.window = window
        coordinator.window?.makeKeyAndVisible()
        
        server.delegate = self
    }
}


extension Application: ServerDelegate {
    
    func serverDidLaunch(_ server: Server) {
        
        let store = AuthResponseStore()
        
        self.server(server, reauthenticateFromStore: store)
    }
    
    func server(_ server: Server, reauthenticateFromStore store: ResponsePersistable) {
        
        store.fetcher.fetchResponse() { [weak self] result in
            guard let self = self else { return }
            
            self.handleFetchResponse(for: result)
        }
    }
}


extension Application {
    
    private func handleFetchResponse(for result: Result<HTTPUserDTO.Response?, CoreDataError>) {
        switch result {
        case .success(let response):
            
            if let response = response,
               let user = response.data {
                
                return authenticate(user)
            }
            
            coordinateToAuthScene()
            
        case .failure(let error):
            debugPrint(.error, error.localizedDescription)
        }
    }
    
    private func authenticate(_ user: UserDTO) {
        let request = HTTPUserDTO.Request(user: user)
        
        sendRequest(request)
    }
    
    private func sendRequest(_ request: HTTPUserDTO.Request) {
        
        if #available(iOS 13.0.0, *) {
            
            Task {
                if let response: HTTPUserDTO.Response = await server.authService.signIn(request: request) {
                    
                    if let user = response.data,
                       let _ = user.selectedProfile {
                        
                        return DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            
                            self.coordinateToTabBarScene()
                        }
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        self.coordinateToProfileScene()
                    }
                }
            }
            
        } else {
            
            server.authService.signIn(
                with: request,
                cached: { [weak self] response in
                    guard let self = self,
                          let user = response.data?.toDomain() else {
                        return
                    }
                    
                    if let _ = user.selectedProfile {
                        return self.coordinateToTabBarScene()
                    }
                    
                    self.coordinateToProfileScene()
                },
                completion: nil)
        }
    }
}


extension Application {
    
    private func coordinateToTabBarScene() {
        let tabBarCoordinator = coordinator.tabBarCoordinator
        
        coordinator.coordinate(to: tabBarCoordinator?.viewController)
    }
    
    private func coordinateToAuthScene() {
        let authCoordinator = coordinator.authCoordinator
        
        coordinator.coordinate(to: authCoordinator?.navigationController)
    }
    
    private func coordinateToProfileScene() {
        let profileCoordinator = coordinator.profileCoordinator
        
        coordinator.coordinate(to: profileCoordinator?.navigationController)
    }
}
