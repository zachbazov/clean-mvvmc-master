//
//  ResponseUpdatable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 12/11/2023.
//

import CoreData

protocol ResponseUpdatable {
    
    func updateResponse<T>(_ response: T) where T: Decodable
}
