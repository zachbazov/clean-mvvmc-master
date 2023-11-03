//
//  HTTPProfileDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

struct HTTPProfileDTO {
    
    struct GET: HTTPRepresentable {
        
        struct Request: Decodable {
            let user: UserDTO
            var _id: String?
        }
        
        
        struct Response: Decodable {
            let status: String
            let results: Int
            let data: [ProfileDTO]
        }
    }
    
    
    struct POST: HTTPRepresentable {
        
        struct Request: Decodable {
            let user: UserDTO
            let profile: ProfileDTO
        }
        
        
        struct Response: Decodable {
            let status: String
            let data: ProfileDTO
        }
    }
    
    
    struct PATCH: HTTPRepresentable {
        
        struct Request: Decodable {
            let user: UserDTO
            var id: String? = nil
            let profile: ProfileDTO
        }
        
        
        struct Response: Decodable {
            let status: String
            let data: ProfileDTO
        }
    }
    
    
    struct DELETE: HTTPRepresentable {
        
        struct Request: Decodable {
            let user: UserDTO
            let id: String
        }
        
        
        struct Response: Decodable {
            let status: String
            var message: String?
        }
    }
}


extension HTTPProfileDTO.GET.Response {
    
    func toDomain() -> HTTPProfile.GET.Response {
        return HTTPProfile.GET.Response(status: status,
                                        results: results,
                                        data: data.toDomain())
    }
}

extension HTTPProfileDTO.POST.Response {
    
    func toDomain() -> HTTPProfile.POST.Response {
        return HTTPProfile.POST.Response(status: status,
                                         data: data.toDomain())
    }
}

extension HTTPProfileDTO.PATCH.Response {
    
    func toDomain() -> HTTPProfile.PATCH.Response {
        return HTTPProfile.PATCH.Response(status: status,
                                          data: data.toDomain())
    }
}

extension HTTPProfileDTO.DELETE.Response {
    
    func toDomain() -> HTTPProfile.DELETE.Response {
        return HTTPProfile.DELETE.Response(status: status)
    }
}
