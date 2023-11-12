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
        
        store.fetcher.fetchResponse() { [weak self] (result: Result<HTTPUserDTO.Response?, CoreDataError>) in
            guard let self = self else {
                return
            }
            
            if case let .success(response?) = result {
                
                if let user = response.data {
                    
                    server.authService.updateUser(for: response)
                    
                    if #available(iOS 13.0.0, *) {
                        
                        Task {
                            
                            guard let validity = await server.authService.validateToken() else {
                                return
                            }
                            
                            DispatchQueue.main.async {
                                
                                switch validity {
                                case .expired:
                                    
                                    self.coordinateToAuthScene()
                                    
                                case .success:
                                    
                                    if let _ = user.selectedProfile {
                                        
                                        self.coordinateToTabBarScene()
                                        
                                    } else {
                                        
                                        self.coordinateToProfileScene()
                                    }
                                    
                                default:
                                    break
                                }
                            }
                        }
                        
                    } else {
                        
                        server.authService.validateToken(
                            success: {
                                
                                if let _ = user.selectedProfile {
                                    
                                    DispatchQueue.main.async {
                                        self.coordinateToTabBarScene()
                                    }
                                    
                                } else {
                                    
                                    DispatchQueue.main.async {
                                        self.coordinateToProfileScene()
                                    }
                                }
                            }, expired: {
                                
                                DispatchQueue.main.async {
                                    self.coordinateToAuthScene()
                                }
                            })
                    }
                }
                
            } else {
                
                self.coordinateToAuthScene()
            }
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
