//
//  HTTPUserDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import CoreData

struct HTTPUserDTO: HTTPRepresentable {
    
    struct Request: Decodable {
        let user: UserDTO
        var selectedProfile: String?
    }
    
    
    struct Response: Decodable {
        var message: String?
        var status: String?
        var token: String?
        var data: UserDTO?
    }
}


extension HTTPUserDTO.Request {
    
    func toDomain() -> HTTPUser.Request {
        return HTTPUser.Request(user: user.toDomain(),
                                selectedProfile: selectedProfile)
    }
}

extension HTTPUserDTO.Response {
    
    func toDomain() -> HTTPUser.Response {
        return HTTPUser.Response(status: status,
                                 token: token,
                                 data: data?.toDomain())
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
        return HTTPUserDTO.Response(status: status,
                                    token: token,
                                    data: data)
    }
}
