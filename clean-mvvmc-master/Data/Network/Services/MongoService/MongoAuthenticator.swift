//
//  MongoAuthenticator.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation
import CodeBureau
import Cryptographic

final class MongoAuthenticator: MongoAuthenticable {
    
    var user: UserDTO?
}


extension MongoAuthenticator: MongoAuthRequestable {
    
    func signIn(_ request: HTTPUserDTO.Request,
                error: ((HTTPServerErrorDTO.Response) -> Void)?,
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
                    responseStore.deleter.delete()
                    responseStore.saver.save(response, withRequest: request)
                    
                    completion?(response)
                    
                case .failure(let error):
                    debugPrint(.error, error.localizedDescription)
                }
            })
    }
}


extension MongoAuthenticator {
    
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
        let responseStore = UserResponseStore()
        responseStore.deleter.delete()
    }
}
