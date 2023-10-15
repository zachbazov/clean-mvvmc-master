//
//  AuthService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

final class AuthService {
    
    static var shared = AuthService()
    
    private init() {
    }
    
    
    var user: UserDTO?
    
    let responses = UserResponseStore()
    
    
    func setUser(with request: HTTPUserDTO.Request?, response: HTTPUserDTO.Response) {
        
        // selectedprofile
        
        user = response.data
        user?.token = response.token
        
        if let request = request {
            user?.password = request.user.password
        }
    }
}
