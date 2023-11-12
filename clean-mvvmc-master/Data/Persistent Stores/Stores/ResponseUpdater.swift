//
//  ResponseUpdater.swift
//  clean-mvvmc-master
//
//  Created by Developer on 12/11/2023.
//

import CoreData

struct ResponseUpdater<E>: ResponseUpdatable where E: NSManagedObject {
    
    func updateResponse<T>(_ response: T) where T: Decodable {
        
        let coreDataService = CoreDataService.shared
        
        guard updateResponse(response, in: coreDataService.context()) else {
            return
        }
        
        coreDataService.saveContext()
    }
}


extension ResponseUpdater {
    
    private func updateResponse<T>(_ response: T, in context: NSManagedObjectContext) -> Bool where T: Decodable {
        
        switch response {
            
        case let response as HTTPUserDTO.Response:
            
            let fetchRequest = E.fetchRequest()
            
            do {
                
                if let result = try context.fetch(fetchRequest).first as? UserResponseEntity {
                    
                    result.data = response.data
                    
                    return true
                }
                
                return false
                
            } catch {
                print(error)
                return false
            }
            
        default:
            return false
        }
    }
}
