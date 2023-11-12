//
//  AuthRequestable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 21/10/2023.
//

import Foundation

protocol AuthRequestable {
    
    func signIn(with request: HTTPUserDTO.Request,
                cached: ((HTTPUserDTO.Response) -> Void)?,
                completion: ((HTTPUserDTO.Response) -> Void)?)
    
    func signUp(with request: HTTPUserDTO.Request, completion: @escaping () -> Void)
    
    func signOut(completion: ((Bool) -> Void)?)
    
    @available(iOS 13.0.0, *)
    func signUp(request: HTTPUserDTO.Request) async -> HTTPUserDTO.Response?
    
    @available(iOS 13.0.0, *)
    func signIn(request: HTTPUserDTO.Request) async -> HTTPUserDTO.Response?
    
    @available(iOS 13.0.0, *)
    func signOut() async -> Void?
    
    
    var user: User? { get set }
    
    var cookie: HTTPCookie? { get set }
    
    var jwt: JWT<PayloadStandardJWT>? { get set }
    
    func updateUser(for response: HTTPUserDTO.Response?)
    
    func validateToken(success: (() -> Void)?, expired: (() -> Void)?)
    
    @available(iOS 13.0.0, *)
    func validateToken() async -> ValidatePayloadResult?
}
