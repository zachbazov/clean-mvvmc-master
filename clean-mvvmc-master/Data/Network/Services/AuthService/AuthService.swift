//
//  AuthService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation
import CodeBureau

final class AuthService {
    
    private let responseStore = AuthResponseStore()
    
    private let useCase = AuthUseCase()
    
    
    var user: User?
    
    var cookie: HTTPCookie?
    
    var jwt: JWT<PayloadStandardJWT>?
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
                    
                    self.validateToken()
                    
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
                    
                    self.validateToken()
                    
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
                    
                    self.validateToken()
                    
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
        
        await validateToken()
        
        return response
    }
    
    @available(iOS 13.0.0, *)
    func signIn(request: HTTPUserDTO.Request) async -> HTTPUserDTO.Response? {
        
        let response: HTTPUserDTO.Response? = await useCase.request(endpoint: .signIn, request: request)
        
        guard response?.status == "success" else {
            return nil
        }
        
        updateUser(for: response)
        
        await validateToken()
        
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
        self.user?.token = response?.token
    }
    
    func validateToken(success: (() -> Void)? = nil, expired: (() -> Void)? = nil) {
        
        guard let token = user?.token else {
            return
        }
        
        do {
            
            jwt = try JWT<PayloadStandardJWT>(jwtString: token, verifier: .hs256(key: secretKeyData))
            
            jwt?.payload.log()
            
            guard let payloadValidity = jwt?.validatePayload() else {
                return
            }
            
            switch payloadValidity {
            case .expired:
                
                responseStore.deleter.deleteResponse()
                
                expired?()
                
            case .success:
                
                success?()
                
            default:
                break
            }
        } catch {
            debugPrint(.debug, "AuthService JWT Error \(error)")
        }
    }
    
    @available(iOS 13.0.0, *)
    @discardableResult
    func validateToken() async -> ValidatePayloadResult? {
        
        guard let token = user?.token else {
            return nil
        }

        do {
            jwt = try JWT<PayloadStandardJWT>(jwtString: token, verifier: .hs256(key: secretKeyData))
            
            jwt?.payload.log()

            guard let payloadValidity = try await jwt?.validatePayload() else {
                return nil
            }
            
            switch payloadValidity {
            case .expired:
                
                responseStore.deleter.deleteResponse()
                
                return .expired
                
            case .success:
                return .success
            default:
                return nil
            }
        } catch {
            debugPrint(.debug, "AuthService JWT Error \(error)")
        }
        
        return nil
    }
}
