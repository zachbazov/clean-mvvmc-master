//
//  ProfileResponseStore.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/11/2023.
//

import Foundation

struct ProfileResponseStore: ResponsePersistable {
    
    let fetcher: ResponseFetchable
    let updater: ResponseUpdatable
    let saver: ResponseSavable
    let deleter: ResponseDeletable
    
    
    init<E>(fetcher: ResponseFetcher<E> = ResponseFetcher<ProfileResponseEntity>(),
            saver: ResponseSavable = ResponseSaver(),
            updater: ResponseUpdater<E> = ResponseUpdater<ProfileResponseEntity>(),
            deleter: ResponseDeleter<E> = ResponseDeleter<ProfileResponseEntity>()) {
        self.fetcher = fetcher
        self.saver = saver
        self.updater = updater
        self.deleter = deleter
    }
}
