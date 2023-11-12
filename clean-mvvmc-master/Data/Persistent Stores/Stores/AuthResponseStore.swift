//
//  AuthResponseStore.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import CoreData

struct AuthResponseStore: ResponsePersistable {
    
    let fetcher: ResponseFetchable
    let saver: ResponseSavable
    let updater: ResponseUpdatable
    let deleter: ResponseDeletable
    
    
    init<E>(fetcher: ResponseFetcher<E> = ResponseFetcher<UserResponseEntity>(),
            saver: ResponseSavable = ResponseSaver(),
            updater: ResponseUpdater<E> = ResponseUpdater<UserResponseEntity>(),
            deleter: ResponseDeleter<E> = ResponseDeleter<UserResponseEntity>()) {
        self.fetcher = fetcher
        self.saver = saver
        self.updater = updater
        self.deleter = deleter
    }
}
