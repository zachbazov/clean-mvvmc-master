//
//  HTTPMediaDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import CoreData

struct HTTPMediaDTO: HTTPRepresentable {
    
    struct Request: Decodable {
        var id: String?
        var slug: String?
    }
    
    
    struct Response: Codable {
        let status: String
        let results: Int
        let data: [MediaDTO]
    }
}


extension HTTPMediaDTO.Response {
    
    func toDomain() -> HTTPMedia.Response {
        return HTTPMedia.Response(status: status,
                                  results: results,
                                  data: data.toDomain())
    }
}


extension HTTPMediaDTO.Response {
    
    func toEntity(in context: NSManagedObjectContext) -> MediaResponseEntity {
        let entity = MediaResponseEntity(context: context)
        
        entity.status = status
        entity.results = Int32(results)
        entity.data = data
        
        return entity
    }
}
