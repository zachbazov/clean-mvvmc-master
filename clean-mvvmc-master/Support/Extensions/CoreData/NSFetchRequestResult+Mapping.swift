//
//  NSFetchRequestResult+Mapping.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import CoreData

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
