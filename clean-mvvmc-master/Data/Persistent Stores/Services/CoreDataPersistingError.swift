//
//  CoreDataPersistingError.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

enum CoreDataPersistingError: Error {
    
    case read(Error)
    case save(Error)
    case delete(Error)
}
