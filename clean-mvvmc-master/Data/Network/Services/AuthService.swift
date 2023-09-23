//
//  AuthService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation
import CodeBureau

final class AuthService {
    
    var user: UserDTO?
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
                    self.verifyJWTIntegrity()
                    
                    return cached?(response) ?? {}()
                }
            },
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    
                    self.updateUser(for: response, withRequest: request)
                    self.verifyJWTIntegrity()
                    
                    let responseStore = UserResponseStore()
                    responseStore.saveResponse(response, withRequest: request)
                    
                    completion?(response)
                    
                case .failure(let error):
                    debugPrint(.error, error.localizedDescription)
                }
            })
    }
}


extension AuthService {
    
    private var secretKeyData: Data {
        let key = Bundle.main.object(forInfoDictionaryKey: "JWT Secret") as! String
        return key.data(using: .utf8)!
    }
    
    
    func updateUser(for response: HTTPUserDTO.Response, withRequest request: HTTPUserDTO.Request?) {
        guard let responseData = response.data else { return }
        
        user = responseData
        user?._id = responseData._id
        
        if let request = request {
            user?.password = request.user.password
        }
        
        if let token = response.token {
            user?.token = token
        }
    }
    
    func verifyJWTIntegrity() {
        guard let token = user?.token else { return }
        
        do {
            let jwt = try JWT<PayloadStandardJWT>(jwtString: token,
                                                  verifier: .hs256(key: secretKeyData))
            
            jwt.payload.log()
            
            let payloadValidity = jwt.validatePayload()
            switch payloadValidity {
            case .expired:
                deleteCurrentUserResponseFromStore()
            default:
                break
            }
        } catch {
            debugPrint(.debug, "AuthService JWT Error \(error)")
        }
    }
    
    private func deleteCurrentUserResponseFromStore() {
        guard let user = user else { return }
        
        let coreDataService = CoreDataService.shared
        let request = HTTPUserDTO.Request(user: user)
        let responseStore = UserResponseStore()
        responseStore.deleteResponse(withRequest: request, in: coreDataService.context())
    }
}
