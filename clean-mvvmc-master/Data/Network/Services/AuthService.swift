//
//  AuthService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation
import CodeBureau

final class AuthService {
    
    static var shared = AuthService()
    
    private init() {
    }
    
    
    var user: UserDTO?
    
    let userResponseStore = UserResponseStore()
}


extension AuthService {
    
    func setUser(with request: HTTPUserDTO.Request?, response: HTTPUserDTO.Response) {
        
        // selectedprofile
        
        user = response.data
        user?.token = response.token
        
        if let request = request {
            user?.password = request.user.password
        }
    }
    
    func signOut(completion: ((Bool) -> Void)?) {
        
        let useCase = AuthUseCase()
        
        useCase.request(
            endpoint: .signOut,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    
                    self.userResponseStore.deleter.delete()
                    
                    completion?(true)
                    
                case .failure(let error):
                    debugPrint(.error, error.localizedDescription)
                    
                    completion?(false)
                }
            })
    }
}
