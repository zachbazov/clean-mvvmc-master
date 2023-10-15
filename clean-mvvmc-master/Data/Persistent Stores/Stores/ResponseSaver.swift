//
//  ResponseSaver.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

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
