//
//  AuthViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 25/09/2023.
//

import Foundation

final class AuthViewModel: ViewModel {
    
    var coordinator: AuthCoordinator?
}

// MARK: - Internal Implementation

extension AuthViewModel {
    
    func signUp(with request: HTTPUserDTO.Request, completion: @escaping () -> Void) {
        
        let authService = Application.app.server.authService
        
        authService.signUp(with: request, completion: completion)
    }
    
    @available(iOS 13.0.0, *)
    @discardableResult
    func signUp(with request: HTTPUserDTO.Request) async -> HTTPUserDTO.Response? {
        
        let authService = Application.app.server.authService
        
        return await authService.signUp(request: request)
    }
    
    func signIn(with request: HTTPUserDTO.Request,
                completion: @escaping (HTTPUserDTO.Response) -> Void) {
        
        let authService = Application.app.server.authService
        
        authService.signIn(with: request, cached: nil, completion: completion)
    }
    
    @available(iOS 13.0.0, *)
    @discardableResult
    func signIn(with request: HTTPUserDTO.Request) async -> HTTPUserDTO.Response? {
        
        let authService = Application.app.server.authService
        
        return await authService.signIn(request: request)
    }
}
