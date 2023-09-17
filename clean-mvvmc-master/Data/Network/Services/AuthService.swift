//
//  AuthService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

final class AuthService {
    
    var user: UserDTO?
}


extension AuthService {
    
    func signIn(_ request: HTTPUserDTO.Request) {
        let useCase = AuthUseCase()
        
        useCase.request(
            endpoint: .signIn,
            request: request,
            cached: nil,
            completion: { result in
                switch result {
                case .success(let response):
                    self.user = response.data
                    self.user?.token = response.token
                case .failure(let error):
                    debugPrint(.error, error.localizedDescription)
                }
            })
    }
}
