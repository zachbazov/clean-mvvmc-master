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
    let deleter: ResponseDeletable
    
    
    init<E>(fetcher: ResponseFetcher<E> = ResponseFetcher<MediaResponseEntity>(),
            saver: ResponseSavable = ResponseSaver(),
            deleter: ResponseDeleter<E> = ResponseDeleter<MediaResponseEntity>()) {
        self.fetcher = fetcher
        self.saver = saver
        self.deleter = deleter
    }
}
