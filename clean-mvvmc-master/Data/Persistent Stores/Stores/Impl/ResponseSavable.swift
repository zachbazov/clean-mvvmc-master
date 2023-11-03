//
//  ResponseSavable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

protocol ResponseSavable {
    
    func saveResponse<T>(_ response: T) where T: Decodable
}
