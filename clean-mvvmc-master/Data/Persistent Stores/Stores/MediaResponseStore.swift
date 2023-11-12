//
//  MediaResponseStore.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import Foundation

struct MediaResponseStore: ResponsePersistable {
    
    let fetcher: ResponseFetchable
    let saver: ResponseSavable
    let updater: ResponseUpdatable
    let deleter: ResponseDeletable
    
    
    init<E>(fetcher: ResponseFetcher<E> = ResponseFetcher<MediaResponseEntity>(),
            saver: ResponseSavable = ResponseSaver(),
            updater: ResponseUpdater<E> = ResponseUpdater<MediaResponseEntity>(),
            deleter: ResponseDeleter<E> = ResponseDeleter<MediaResponseEntity>()) {
        self.fetcher = fetcher
        self.saver = saver
        self.updater = updater
        self.deleter = deleter
    }
}
