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
                    
                    server.authService.user = user.toDomain()
                    
                    if let _ = user.selectedProfile {
                        
                        return DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            
                            self.coordinateToTabBarScene()
                        }
                    }
                    
                    return DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        self.coordinateToProfileScene()
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



/*
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
                     
                     server.authService.user = user.toDomain()
                     server.authService.user?.password = "qweqweqwe"
                     
                     let req = HTTPUserDTO.Request(user: server.authService.user!.toDTO())
                     
                     let sessionTask = URLSessionTask()
                     
                     guard !sessionTask.isCancelled else { return }
                     
                     let endpoint = AuthRepository.signIn(with: req)
                     
                     sessionTask.task = server.dataTransferService.request(endpoint: endpoint, completion: { (result: Result<HTTPUserDTO.Response, DataTransferError>) in
                         switch result {
                         case .success(let response):
                             print(12, response.token)
                             let cookieProperties: [HTTPCookiePropertyKey: Any] = [
                                 .name: "jwt",
                                 .value: "asd",
                                 .path: "/",
                                 .domain: "http://localhost:3000/",
                             ]

                             if let cookie = HTTPCookie(properties: cookieProperties) {
                                 HTTPCookieStorage.shared.setCookie(cookie)
                                 
                                 server.authService.cookie = cookie
                             }
                             
                             if let _ = response.data?.selectedProfile {
                                 
                                 return DispatchQueue.main.async { [weak self] in
                                     guard let self = self else { return }
                                     
                                     self.coordinateToTabBarScene()
                                 }
                             }
                             
                             return DispatchQueue.main.async { [weak self] in
                                 guard let self = self else { return }
                                 
                                 self.coordinateToProfileScene()
                             }
                         case .failure(let error):
                             print(error)
                         }
                     })
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

 */
