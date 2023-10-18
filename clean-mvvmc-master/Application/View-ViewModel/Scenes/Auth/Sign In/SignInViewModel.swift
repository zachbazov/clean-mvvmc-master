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
    
    let useCase = AuthUseCase()
}

// MARK: - Internal Implementation

extension SignInViewModel {
    
    func signIn(with request: HTTPUserDTO.Request, completion: @escaping (UserDTO?) -> Void) {
        
        let authService = AuthService.shared
        
        useCase.request(
            endpoint: .signIn,
            request: request,
            error: nil,
            cached: { response in
                guard let response = response,
                      let user = response.data else {
                    return
                }
                
                authService.setUser(with: request, response: response)
                
                completion(user)
            },
            completion: { result in
                switch result {
                case .success(let response):
                    
                    authService.setUser(with: request, response: response)
                    
                    authService.responses.saver.save(response, withRequest: request)
                    
                    DispatchQueue.main.async {
                        if let user = response.data {
                            
                            return completion(user)
                        }
                        
                        completion(nil)
                    }
                    
                case .failure(let error):
                    debugPrint(.error, error.localizedDescription)
                }
            })
    }
}
