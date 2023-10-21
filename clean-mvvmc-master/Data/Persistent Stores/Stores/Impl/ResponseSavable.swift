//
//  ResponseSavable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

protocol ResponseSavable {
    
    func saveResponse<T, U>(_ response: T, with request: U) where T: Decodable, U: Decodable
}
