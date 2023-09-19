//
//  HTTPUserDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import CoreData

struct HTTPUserDTO {
    
    struct Request: Decodable {
        let user: UserDTO
        var selectedProfile: String?
    }
    
    
    struct Response: Decodable {
        var status: String?
        var token: String?
        var data: UserDTO?
        
        var message: String?
    }
}


extension HTTPUserDTO.Response {
    
    func toEntity(in context: NSManagedObjectContext) -> UserResponseEntity {
        let entity = UserResponseEntity(context: context)
        
        entity.status = status
        entity.token = token
        entity.data = data
        
        return entity
    }
}


extension UserResponseEntity {
    
    func toDTO() -> HTTPUserDTO.Response? {
        guard let token = token else { return nil }
        
        return HTTPUserDTO.Response(status: status,
                                    token: token,
                                    data: data)
    }
}
