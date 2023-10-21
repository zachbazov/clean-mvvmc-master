//
//  ResponseFetcher.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData

struct ResponseFetcher<T>: ResponseFetchable where T: NSManagedObject {
    
    func fetchResponse(completion: @escaping (Result<HTTPUserDTO.Response?, CoreDataError>) -> Void) {
        
        let context = CoreDataService.shared.context()
        
        do {
            let fetchRequest = T.fetchRequest()
            let responseEntity = try context.fetch(fetchRequest).first
            
            completion(.success(responseEntity?.toDTO()))
        } catch {
            completion(.failure(CoreDataError.read(error)))
        }
    }
}
