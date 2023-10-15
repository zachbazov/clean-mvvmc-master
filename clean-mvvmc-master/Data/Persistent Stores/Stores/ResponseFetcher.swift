//
//  ResponseFetcher.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData

struct ResponseFetcher<Entity>: ResponseFetchable where Entity: NSManagedObject {
    
    func fetch(completion: @escaping (Result<HTTPUserDTO.Response?, CoreDataPersistingError>) -> Void) {
        let context = CoreDataService.shared.context()
        
        do {
            let fetchRequest = Entity.fetchRequest()
            let responseEntity = try context.fetch(fetchRequest).first
            
            completion(.success(responseEntity?.toDTO()))
        } catch {
            completion(.failure(CoreDataPersistingError.read(error)))
        }
    }
    
    func fetch(for request: HTTPUserDTO.Request, completion: @escaping (Result<HTTPUserDTO.Response?, CoreDataPersistingError>) -> Void) {
        let context = CoreDataService.shared.context()
        
        do {
            let fetchRequest = UserResponseEntity.fetchRequest()
            let responseEntity = try context.fetch(fetchRequest).first
            
            completion(.success(responseEntity?.toDTO()))
        } catch {
            completion(.failure(CoreDataPersistingError.read(error)))
        }
    }
}
