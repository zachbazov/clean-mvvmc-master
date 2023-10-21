//
//  ResponseDeleter.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData
import CodeBureau

struct ResponseDeleter: ResponseDeletable {
    
    func deleteResponse<T>(of type: T.Type) where T: NSManagedObject {
        
        let coreDataService = CoreDataService.shared
        
        deleteResponse(for: type, in: coreDataService.context())
        
        coreDataService.saveContext()
    }
}


extension ResponseDeleter {
    
    private func deleteResponse<T>(for type: T.Type, in context: NSManagedObjectContext) where T: NSManagedObject {
        
        do {
            switch type {
            case is UserResponseEntity.Type:
                
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
                
                if let result = try context.fetch(fetchRequest).first {
                    context.delete(result as! NSManagedObject)
                }
            default:
                break
            }
        } catch {
            debugPrint(.error, "Unresolved error \(error) occured as trying to delete object.")
        }
    }
}
