//
//  ServerDelegate.swift
//  clean-mvvmc-master
//
//  Created by Developer on 21/10/2023.
//

import Foundation

protocol ServerDelegate: AnyObject {
    
    func serverDidLaunch(_ server: Server)
    func server(_ server: Server, reauthenticateFromStore store: ResponsePersistable)
}
