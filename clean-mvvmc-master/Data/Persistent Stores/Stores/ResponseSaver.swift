//
//  ResponseSaver.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData

struct ResponseSaver: ResponseSavable {
    
    func saveResponse<T, U>(_ response: T, with request: U) where T: Decodable, U: Decodable {
        
        let coreDataService = CoreDataService.shared
        
        saveResponse(response, in: coreDataService.context())
        
        coreDataService.saveContext()
    }
}


extension ResponseSaver {
    
    private func saveResponse<T>(_ response: T, in context: NSManagedObjectContext) where T: Decodable {
        
        switch response {
        case let response as HTTPUserDTO.Response:
            
            let responseEntity: UserResponseEntity = response.toEntity(in: context)
            
            responseEntity.status = response.status
            responseEntity.token = response.token
            responseEntity.data = response.data
            responseEntity.userId = response.data?._id
            responseEntity.email = response.data?.email
            
        case let response as HTTPSectionDTO.Response:
            
            let responseEntity: SectionResponseEntity = response.toEntity(in: context)
            
            responseEntity.status = response.status
            responseEntity.results = response.results.toInt32()
            responseEntity.data = response.data
            
        case let response as HTTPMediaDTO.Response:
            
            let responseEntity: MediaResponseEntity = response.toEntity(in: context)
            
            responseEntity.status = response.status
            responseEntity.results = response.results.toInt32()
            responseEntity.data = response.data
            
        default:
            break
        }
    }
}
