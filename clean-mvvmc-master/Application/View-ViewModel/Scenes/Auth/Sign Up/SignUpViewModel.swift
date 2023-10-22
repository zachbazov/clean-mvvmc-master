//
//  SignUpViewModel.swift
//  clean-mvvmc-master
//
//  Created by Developer on 26/09/2023.
//

import Foundation
import CodeBureau

// MARK: - SignUpViewModel Type

struct SignUpViewModel: ControllerViewModel {
    
    var coordinator: AuthCoordinator?
}

// MARK: - Internal Implementation

extension SignUpViewModel {
    
    func signUp(with request: HTTPUserDTO.Request, completion: @escaping () -> Void) {
        
        let authService = Application.app.server.authService
        
        authService.signUp(with: request, completion: completion)
    }
    
    @available(iOS 13.0.0, *)
    func signUp(with request: HTTPUserDTO.Request) async -> HTTPUserDTO.Response? {
        
        let authService = Application.app.server.authService
        
        return await authService.signUp(request: request)
    }
}
