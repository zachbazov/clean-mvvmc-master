//
//  UserResponseStore.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import CoreData

struct UserResponseStore: ResponsePersistable {
    
    let fetcher: ResponseFetchable
    let saver: ResponseSavable
    let deleter: ResponseDeletable
    
    
    init<T>(fetcher: ResponseFetcher<T> = ResponseFetcher<UserResponseEntity>(),
            saver: ResponseSavable = ResponseSaver(),
            deleter: ResponseDeletable = ResponseDeleter()) {
        self.fetcher = fetcher
        self.saver = saver
        self.deleter = deleter
    }
}
