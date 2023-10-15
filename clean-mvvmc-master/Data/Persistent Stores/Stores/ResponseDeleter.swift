//
//  ResponseDeleter.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation
import CodeBureau

struct ResponseDeleter: ResponseDeletable {
    
    func delete() {
        let coreDataService = CoreDataService.shared
        let context = coreDataService.context()
        let fetchRequest = UserResponseEntity.fetchRequest()
        
        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
                
                coreDataService.saveContext()
            }
        } catch {
            debugPrint(.error, "Unresolved error \(error) occured as trying to delete object.")
        }
    }
}
