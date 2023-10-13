//
//  MongoAuthenticable.swift
//
//
//  Created by Developer on 29/09/2023.
//

import Foundation

public protocol MongoAuthenticable {
    
    associatedtype UserType: Decodable
    
    var user: UserType? { get }
}
