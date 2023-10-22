//
//  ResponseFetchable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData

protocol ResponseFetchable {
    
    func fetchResponse<T>(completion: @escaping (Result<T?, CoreDataError>) -> Void) where T: Decodable
    
    @available(iOS 13.0.0, *)
    func fetchResponse<T>() -> T? where T: Decodable
}
