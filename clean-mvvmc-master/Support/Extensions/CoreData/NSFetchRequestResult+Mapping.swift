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
            return HTTPUserDTO.Response(status: entity.status,
                                        token: entity.token ?? "",
                                        data: entity.data) as? T
            
        case let entity as ProfileResponseEntity:
            return HTTPProfileDTO.GET.Response(status: entity.status ?? "",
                                               results: entity.results.toInt(),
                                               data: entity.data ?? []) as? T
            
        case let entity as SectionResponseEntity:
            return HTTPSectionDTO.Response(status: entity.status ?? "",
                                           results: entity.results.toInt(),
                                           data: entity.data ?? []) as? T
            
        case let entity as MediaResponseEntity:
            return HTTPMediaDTO.Response(status: entity.status ?? "",
                                         results: entity.results.toInt(),
                                         data: entity.data ?? []) as? T
            
        default:
            return nil
        }
    }
}
