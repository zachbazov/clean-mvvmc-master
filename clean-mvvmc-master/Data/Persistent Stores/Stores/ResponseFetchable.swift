//
//  ResponseFetchable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

protocol ResponseFetchable {
    
    associatedtype RequestType: Decodable
    associatedtype ResponseType: Decodable
    associatedtype ErrorType: Error
    
    func fetch(for request: RequestType, completion: @escaping (Result<ResponseType?, ErrorType>) -> Void)
    func fetch(completion: @escaping (Result<ResponseType?, ErrorType>) -> Void)
}
