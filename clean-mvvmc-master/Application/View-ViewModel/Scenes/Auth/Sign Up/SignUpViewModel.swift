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
    
    let useCase = AuthUseCase()
}

// MARK: - Internal Implementation

extension SignUpViewModel {
    
    func signUp(with request: HTTPUserDTO.Request, completion: @escaping () -> Void) {
        
        let authService = AuthService.shared
        
        useCase.request(
            endpoint: .signUp,
            request: request,
            error: nil,
            cached: nil,
            completion: { result in
                
                switch result {
                case .success(let response):
                    
                    authService.setUser(with: request, response: response)
                    
                    authService.userResponseStore.saver.save(response, withRequest: request)
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                    
                case .failure(let error):
                    debugPrint(.error, error.localizedDescription)
                }
            })
    }
}
