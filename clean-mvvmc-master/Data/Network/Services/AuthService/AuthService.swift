//
//  AuthService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation
import CodeBureau
import Cryptographic

final class AuthService {
    
    var user: User?
    
    private let responseStore = AuthResponseStore()
    
    private let useCase = AuthUseCase()
    
    
    
//    var cookie: HTTPCookie?
}


extension AuthService: AuthRequestable {
    
    func signUp(with request: HTTPUserDTO.Request, completion: @escaping () -> Void) {
        
        useCase.request(
            endpoint: .signUp,
            request: request,
            cached: nil,
            completion: { [weak self] (result: Result<HTTPUserDTO.Response, DataTransferError>) in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let response):
                    
                    self.updateUser(for: response)
                    
                    self.verifyJWTIntegrity()
                    
                    self.responseStore.deleter.deleteResponse()
                    
                    self.responseStore.saver.saveResponse(response)
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                    
                case .failure(let error):
                    debugPrint(.error, error.localizedDescription)
                }
            })
    }
    
    func signIn(with request: HTTPUserDTO.Request,
                cached: ((HTTPUserDTO.Response) -> Void)?,
                completion: ((HTTPUserDTO.Response) -> Void)?) {
        
        useCase.request(
            endpoint: .signIn,
            request: request,
            cached: { [weak self] response in
                guard let self = self else {
                    return
                }
                
                if let response = response {
                    
                    self.updateUser(for: response)
                    
                    self.verifyJWTIntegrity()
                    
                    return cached?(response) ?? Void()
                }
            },
            completion: { [weak self] (result: Result<HTTPUserDTO.Response, DataTransferError>) in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let response):
                    
                    self.updateUser(for: response)
                    
                    self.verifyJWTIntegrity()
                    
                    self.responseStore.deleter.deleteResponse()
                    
                    self.responseStore.saver.saveResponse(response)
                    
                    completion?(response) ?? Void()
                    
                case .failure(let error):
                    debugPrint(.error, error.localizedDescription)
                }
            })
    }
    
    func signOut(completion: ((Bool) -> Void)?) {
        
        useCase.request() { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success:
                
                self.responseStore.deleter.deleteResponse()
                
                completion?(true)
                
            case .failure(let error):
                debugPrint(.error, error.localizedDescription)
                
                completion?(false)
            }
        }
    }
    
    @available(iOS 13.0.0, *)
    func signUp(request: HTTPUserDTO.Request) async -> HTTPUserDTO.Response? {
        
        let response: HTTPUserDTO.Response? = await useCase.request(endpoint: .signUp, request: request)
        
        guard response?.status == "success" else {
            return nil
        }
        
        updateUser(for: response)
        
        verifyJWTIntegrity()
        
        return response
    }
    
    @available(iOS 13.0.0, *)
    func signIn(request: HTTPUserDTO.Request) async -> HTTPUserDTO.Response? {
        
        let response: HTTPUserDTO.Response? = await useCase.request(endpoint: .signIn, request: request)
        
        guard response?.status == "success" else {
            return nil
        }
        
        updateUser(for: response)
        
        verifyJWTIntegrity()
        
        return response
    }
    
    @available(iOS 13.0.0, *)
    func signOut() async -> Void? {
        return await useCase.request()
    }
}


extension AuthService {
    
    private var secretKeyData: Data {
        let key = Bundle.main.object(forInfoDictionaryKey: "JWT Secret") as! String
        
        return key.data(using: .utf8)!
    }
    
    
    func updateUser(for response: HTTPUserDTO.Response?) {
        
        guard let user = response?.data else {
            return
        }
        
        self.user = user.toDomain()
    }
    
    func verifyJWTIntegrity() {
        guard let token = user?.token else {
            return
        }
        
        do {
            let jwt = try JWT<PayloadStandardJWT>(jwtString: token,
                                                  verifier: .hs256(key: secretKeyData))
            
            jwt.payload.log()
            
            let payloadValidity = jwt.validatePayload()
            
            switch payloadValidity {
            case .expired:
                
                responseStore.deleter.deleteResponse()
                
            default:
                break
            }
        } catch {
            debugPrint(.debug, "AuthService JWT Error \(error)")
        }
    }
}
