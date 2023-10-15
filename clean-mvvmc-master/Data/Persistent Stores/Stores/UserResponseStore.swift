//
//  UserResponseStore.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import CoreData

struct UserResponseStore: ResponsePersistable {
    
    let fetcher = ResponseFetcher<UserResponseEntity>()
    let saver = ResponseSaver()
    let deleter = ResponseDeleter()
}
