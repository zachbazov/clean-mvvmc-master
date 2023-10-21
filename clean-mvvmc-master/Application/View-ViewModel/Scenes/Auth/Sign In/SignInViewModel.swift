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
}
