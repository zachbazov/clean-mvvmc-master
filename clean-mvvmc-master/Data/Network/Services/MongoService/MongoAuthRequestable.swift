//
//  MongoAuthRequestable.swift
//
//
//  Created by Developer on 24/09/2023.
//

import Foundation

protocol MongoAuthRequestable {
    
    associatedtype RequestType: Decodable
    associatedtype ResponseType: Decodable
    associatedtype RequestMongoErrorType: Decodable
    
    func signIn(_ request: RequestType,
                error: ((RequestMongoErrorType) -> Void)?,
                cached: ((ResponseType) -> Void)?,
                completion: ((ResponseType?) -> Void)?)
}
