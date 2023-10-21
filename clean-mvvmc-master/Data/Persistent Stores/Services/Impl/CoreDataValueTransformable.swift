//
//  CoreDataValueTransformable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

protocol CoreDataValueTransformable {
    
    func addTransformer<T>(of type: T.Type, for name: NSValueTransformerName) where T: NSObject
}
