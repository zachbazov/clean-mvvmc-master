//
//  ResponseSavable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

protocol ResponseSavable {
    
    associatedtype RequestType: Decodable
    associatedtype ResponseType: Decodable
    
    func save(_ response: ResponseType, withRequest request: RequestType)
}
