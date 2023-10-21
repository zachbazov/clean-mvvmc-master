//
//  ResponseDeletable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData

protocol ResponseDeletable {
    
    func deleteResponse<T>(of type: T.Type) where T: NSManagedObject
}
