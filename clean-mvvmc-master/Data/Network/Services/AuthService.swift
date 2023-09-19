//
//  AuthService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

final class AuthService {
    
    var user: UserDTO?
    
    
    func updateUser(for response: HTTPUserDTO.Response, withRequest request: HTTPUserDTO.Request?) {
        user = response.data
        user?._id = response.data?._id
        user?.token = response.token
        
        if let request = request {
            user?.password = request.user.password
        }
    }
}


extension AuthService {
    
    func signIn(_ request: HTTPUserDTO.Request,
                error: ((HTTPMongoErrorResponseDTO) -> Void)?,
                cached: ((HTTPUserDTO.Response) -> Void)?,
                completion: ((HTTPUserDTO.Response?) -> Void)?) {
        
        let useCase = AuthUseCase()
        
        useCase.request(
            endpoint: .signIn,
            request: request,
            error: error,
            cached: { [weak self] response in
                guard let self = self else { return }
                
                if let response = response {
                    self.updateUser(for: response, withRequest: request)
                    
                    return cached?(response) ?? {}()
                }
            },
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    self.updateUser(for: response, withRequest: request)
                    
                    let responseStore = UserResponseStore()
                    responseStore.saveResponse(response, withRequest: request)
                    
                    completion?(response)
                case .failure(let error):
                    debugPrint(.error, error.localizedDescription)
                }
            })
    }
}
