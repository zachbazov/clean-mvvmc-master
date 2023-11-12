//
//  ResponseDeleter.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData
import CodeBureau

struct ResponseDeleter<E>: ResponseDeletable where E: NSManagedObject {
    
    func deleteResponse() {
        
        let coreDataService = CoreDataService.shared
        
        deleteResponse(in: coreDataService.context())
        
        coreDataService.saveContext()
    }
}


extension ResponseDeleter {
    
    private func deleteResponse(in context: NSManagedObjectContext) {
        
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = E.fetchRequest()
            
            if let result = try context.fetch(fetchRequest).first {
                
                context.delete(result as! NSManagedObject)
            }
        } catch {
            debugPrint(.error, "Unresolved error \(error) occured as trying to delete object.")
        }
    }
}
