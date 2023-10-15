//
//  CoreDataPersistable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData

protocol CoreDataPersistable {
    
    var persistentContainer: NSPersistentContainer { get }
    var mainContext: NSManagedObjectContext { get }
    var privateContext: NSManagedObjectContext { get }
    
    func context() -> NSManagedObjectContext
    func saveContext()
}
