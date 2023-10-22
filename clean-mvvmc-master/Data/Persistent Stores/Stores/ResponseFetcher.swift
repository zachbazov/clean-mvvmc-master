//
//  ResponseFetcher.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData

struct ResponseFetcher<E>: ResponseFetchable where E: NSManagedObject {
    
    func fetchResponse<T>(completion: @escaping (Result<T?, CoreDataError>) -> Void) where T: Decodable {
        
        let context = CoreDataService.shared.context()
        
        do {
            let fetchRequest = E.fetchRequest()
            let responseEntity = try context.fetch(fetchRequest).first
            
            completion(.success(responseEntity?.toDTO()))
        } catch {
            completion(.failure(CoreDataError.read(error)))
        }
    }
    
    @available(iOS 13.0.0, *)
    func fetchResponse<T>() -> T? where T: Decodable {
        
        let context = CoreDataService.shared.context()
        
        do {
            let fetchRequest = E.fetchRequest()
            let responseEntity = try context.fetch(fetchRequest).first
            
            return responseEntity?.toDTO()
        } catch {
            return nil
        }
    }
}
