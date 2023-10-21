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
}
