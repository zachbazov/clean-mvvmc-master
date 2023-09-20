//
//  HTTPSectionDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import CoreData

struct HTTPSectionDTO {
    
    struct Request: Decodable {
        let user: UserDTO
    }
    
    
    struct Response: Decodable {
        let status: String
        let results: Int
        let data: [SectionDTO]
    }
}


extension HTTPSectionDTO.Response {
    
    func toEntity(in context: NSManagedObjectContext) -> SectionResponseEntity {
        
        let authService = MongoService.shared.authService
        let entity = SectionResponseEntity(context: context)
        
        entity.status = status
        entity.results = Int32(results)
        entity.data = data
        entity.userId = authService.user?._id
        
        return entity
    }
}