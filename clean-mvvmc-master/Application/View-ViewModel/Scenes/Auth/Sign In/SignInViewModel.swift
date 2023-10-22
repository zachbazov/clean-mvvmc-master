//
//  SignInViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/09/2023.
//

import Foundation
import CodeBureau

// MARK: - SignInViewModel Type

struct SignInViewModel: ControllerViewModel {
    
    var coordinator: AuthCoordinator?
}

// MARK: - Internal Implementation

extension SignInViewModel {
    
    func signIn(with request: HTTPUserDTO.Request, completion: @escaping (HTTPUserDTO.Response) -> Void) {
        
        let authService = Application.app.server.authService
        
        authService.signIn(with: request, cached: nil, completion: completion)
    }
    
    @available(iOS 13.0.0, *)
    func signIn(with request: HTTPUserDTO.Request) async -> HTTPUserDTO.Response? {
        
        let authService = Application.app.server.authService
        
        return await authService.signIn(request: request)
    }
}
