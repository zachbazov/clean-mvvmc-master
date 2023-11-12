//
//  SectionResponseStore.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import Foundation

struct SectionResponseStore: ResponsePersistable {
    
    let fetcher: ResponseFetchable
    let saver: ResponseSavable
    let updater: ResponseUpdatable
    let deleter: ResponseDeletable
    
    
    init<E>(fetcher: ResponseFetcher<E> = ResponseFetcher<SectionResponseEntity>(),
            saver: ResponseSavable = ResponseSaver(),
            updater: ResponseUpdater<E> = ResponseUpdater<SectionResponseEntity>(),
            deleter: ResponseDeleter<E> = ResponseDeleter<SectionResponseEntity>()) {
        self.fetcher = fetcher
        self.saver = saver
        self.updater = updater
        self.deleter = deleter
    }
}
