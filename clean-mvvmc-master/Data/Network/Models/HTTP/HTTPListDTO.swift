//
//  HTTPListDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct HTTPListDTO {
    
    struct GET: HTTPRepresentable {
        
        struct Request: Decodable {
            let user: UserDTO
            var media: [MediaDTO]?
        }
        
        
        struct Response: Decodable {
            let status: String
            var data: [ListDTO<MediaDTO>]
        }
    }
    
    struct PATCH: HTTPRepresentable {
        
        struct Request: Decodable {
            let user: String
            let media: [String]
        }
        
        
        struct Response: Decodable {
            let status: String
            var data: ListDTO<String>
        }
    }
}


extension HTTPListDTO.GET.Response {
    
    func toDomain() -> HTTPList.GET.Response {
        return HTTPList.GET.Response(status: status,
                                     data: data.toDomain())
    }
}

extension HTTPListDTO.PATCH.Response {
    
    func toDomain() -> HTTPList.PATCH.Response {
        return HTTPList.PATCH.Response(status: status,
                                       data: data.toDomain())
    }
}


extension Array where Element == ListDTO<MediaDTO> {
    
    func toDomain() -> List<Media> {
        return map { $0 }.toDomain()
    }
}

extension Array where Element == ListDTO<String> {
    
    func toDomain() -> List<String> {
        return map { $0 }.toDomain()
    }
}
