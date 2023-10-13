//
//  UserResponseStore.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import CoreData
import CodeBureau

protocol ResponseFetchable {
    
    associatedtype RequestType: Decodable
    associatedtype ResponseType: Decodable
    associatedtype ErrorType: Error
    
    func fetch(for request: RequestType, completion: @escaping (Result<ResponseType?, ErrorType>) -> Void)
    func fetch(completion: @escaping (Result<ResponseType?, ErrorType>) -> Void)
}

protocol ResponseSavable {
    
    associatedtype RequestType: Decodable
    associatedtype ResponseType: Decodable
    
    func save(_ response: ResponseType, withRequest request: RequestType)
}

protocol ResponseDeletable {
    func delete()
}

struct ResponseFetcher<Entity>: ResponseFetchable where Entity: NSManagedObject {
    
    func fetch(completion: @escaping (Result<HTTPUserDTO.Response?, CoreDataStoreError>) -> Void) {
        let context = CoreDataService.shared.context()
        
        do {
            let fetchRequest = Entity.fetchRequest()
            let responseEntity = try context.fetch(fetchRequest).first
            
            completion(.success(responseEntity?.toDTO()))
        } catch {
            completion(.failure(CoreDataStoreError.read(error)))
        }
    }
    
    func fetch(for request: HTTPUserDTO.Request, completion: @escaping (Result<HTTPUserDTO.Response?, CoreDataStoreError>) -> Void) {
        let context = CoreDataService.shared.context()
        
        do {
            let fetchRequest = UserResponseEntity.fetchRequest()
            let responseEntity = try context.fetch(fetchRequest).first
            
            completion(.success(responseEntity?.toDTO()))
        } catch {
            completion(.failure(CoreDataStoreError.read(error)))
        }
    }
}

struct ResponseSaver: ResponseSavable {
    func save(_ response: HTTPUserDTO.Response, withRequest request: HTTPUserDTO.Request) {
        let coreDataService = CoreDataService.shared
        
        let responseEntity: UserResponseEntity = response.toEntity(in: coreDataService.context())
        
        responseEntity.status = response.status
        responseEntity.token = response.token
        responseEntity.data = response.data
        responseEntity.userId = response.data?._id
        responseEntity.email = response.data?.email
        
        coreDataService.saveContext()
    }
}

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

protocol CoreDataEntity {
    
    associatedtype EntityType: NSManagedObject
    
    static func fetchReq() -> NSFetchRequest<EntityType>
}
extension NSManagedObject: CoreDataEntity {
    static func fetchReq() -> NSFetchRequest<UserResponseEntity> {
        return NSFetchRequest<EntityType>(entityName: String(describing: EntityType.self))
    }
}
extension NSFetchRequestResult {
    func toDTO<T: Decodable>() -> T? {
        switch self {
        case let entity as UserResponseEntity:
            guard let token = entity.token else { return nil }
            
            return HTTPUserDTO.Response(status: entity.status,
                                        token: token,
                                        data: entity.data) as? T
        default:
            return nil
        }
    }
}

protocol RespPersistable {
    associatedtype Fetcher: ResponseFetchable
    associatedtype Saver: ResponseSavable
    associatedtype Deleter: ResponseDeletable
    
    var fetcher: Fetcher { get }
    var saver: Saver { get }
    var deleter: Deleter { get }
}

struct UserResponseStore: RespPersistable {
    let fetcher = ResponseFetcher<UserResponseEntity>()
    let saver = ResponseSaver()
    let deleter = ResponseDeleter()
}


//struct UserResponseStore: ResponsePersistable {
//    
//    func fetchRequest(for request: HTTPUserDTO.Request) -> NSFetchRequest<UserResponseEntity> {
//        let fetchRequest = UserResponseEntity.fetchRequest()
//        
////        fetchRequest.predicate = NSPredicate(format: "email = %@", request.user.email!)
//        
//        return fetchRequest
//    }
//    
//    func fetchResponse(for request: HTTPUserDTO.Request, completion: @escaping (Result<HTTPUserDTO.Response?, CoreDataStoreError>) -> Void) {
//        let context = CoreDataService.shared.context()
//
//        do {
//            let fetchRequest = self.fetchRequest(for: request)
//            let responseEntity = try context.fetch(fetchRequest).first
//            
//            completion(.success(responseEntity?.toDTO()))
//        } catch {
//            completion(.failure(CoreDataStoreError.read(error)))
//        }
//    }
//    
//    func fetchResponse(completion: @escaping (Result<HTTPUserDTO.Response?, CoreDataStoreError>) -> Void) {
//        let context = CoreDataService.shared.context()
//
//        do {
//            let fetchRequest = UserResponseEntity.fetchRequest()
//            let responseEntity = try context.fetch(fetchRequest).first
//            
//            completion(.success(responseEntity?.toDTO()))
//        } catch {
//            completion(.failure(CoreDataStoreError.read(error)))
//        }
//    }
//    
//    func saveResponse(_ response: HTTPUserDTO.Response, withRequest request: HTTPUserDTO.Request) {
//        let context = CoreDataService.shared.context()
//        
//        deleteResponse(withRequest: request, in: context)
//        
//        let responseEntity: UserResponseEntity = response.toEntity(in: context)
//        
//        responseEntity.status = response.status
//        responseEntity.token = response.token
//        responseEntity.data = response.data
//        responseEntity.userId = response.data?._id
//        responseEntity.email = response.data?.email
//        
//        CoreDataService.shared.saveContext()
//    }
//    
//    func deleteResponse(withRequest request: HTTPUserDTO.Request, in context: NSManagedObjectContext) {
//        let fetchRequest = self.fetchRequest(for: request)
//        
//        do {
//            for result in (try context.fetch(fetchRequest)) {
//                context.delete(result)
//                
//                CoreDataService.shared.saveContext()
//            }
//        } catch {
//            debugPrint(.error, "Unresolved error \(error) occured as trying to delete object.")
//        }
//    }
//}
