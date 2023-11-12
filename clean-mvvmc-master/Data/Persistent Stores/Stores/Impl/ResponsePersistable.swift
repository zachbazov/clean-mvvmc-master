//
//  ResponsePersistable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

protocol ResponsePersistable {
    
    var fetcher: ResponseFetchable { get }
    var saver: ResponseSavable { get }
    var updater: ResponseUpdatable { get }
    var deleter: ResponseDeletable { get }
    
    init<E>(fetcher: ResponseFetcher<E>,
            saver: ResponseSavable,
            updater: ResponseUpdater<E>,
            deleter: ResponseDeleter<E>)
}
