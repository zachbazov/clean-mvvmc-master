//
//  UserResponseStore.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import CoreData
import CodeBureau

struct UserResponseStore: ResponsePersistable {
    
    func fetchRequest(for request: HTTPUserDTO.Request) -> NSFetchRequest<UserResponseEntity> {
        let fetchRequest = UserResponseEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "email = %@", request.user.email!)
        
        return fetchRequest
    }
    
    func fetchResponse(for request: HTTPUserDTO.Request, completion: @escaping (Result<HTTPUserDTO.Response?, CoreDataStoreError>) -> Void) {
        let context = CoreDataService.shared.context()

        do {
            let fetchRequest = self.fetchRequest(for: request)
            let responseEntity = try context.fetch(fetchRequest).first
            
            completion(.success(responseEntity?.toDTO()))
        } catch {
            completion(.failure(CoreDataStoreError.read(error)))
        }
    }
    
    func saveResponse(_ response: HTTPUserDTO.Response, withRequest request: HTTPUserDTO.Request) {
        let context = CoreDataService.shared.context()
        
        deleteResponse(withRequest: request, in: context)
        
        let responseEntity: UserResponseEntity = response.toEntity(in: context)
        
        responseEntity.status = response.status
        responseEntity.token = response.token
        responseEntity.data = response.data
        responseEntity.userId = response.data?._id
        responseEntity.email = response.data?.email
        
        CoreDataService.shared.saveContext()
    }
    
    func deleteResponse(withRequest request: HTTPUserDTO.Request, in context: NSManagedObjectContext) {
        let fetchRequest = self.fetchRequest(for: request)
        
        do {
            for result in (try context.fetch(fetchRequest)) {
                context.delete(result)
                
                CoreDataService.shared.saveContext()
            }
        } catch {
            debugPrint(.error, "Unresolved error \(error) occured as trying to delete object.")
        }
    }
}
