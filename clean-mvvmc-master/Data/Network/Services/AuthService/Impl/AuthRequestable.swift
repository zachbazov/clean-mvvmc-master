//
//  AuthRequestable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 21/10/2023.
//

import Foundation

protocol AuthRequestable {
    
    var user: User? { get }
    
    func signIn(with request: HTTPUserDTO.Request,
                cached: ((HTTPUserDTO.Response) -> Void)?,
                completion: ((HTTPUserDTO.Response) -> Void)?)
    
    func signUp(with request: HTTPUserDTO.Request, completion: @escaping () -> Void)
    
    func signOut(completion: ((Bool) -> Void)?)
}
