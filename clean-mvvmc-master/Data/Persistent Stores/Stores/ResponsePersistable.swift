//
//  ResponsePersistable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

protocol ResponsePersistable {
    
    associatedtype Fetcher: ResponseFetchable
    associatedtype Saver: ResponseSavable
    associatedtype Deleter: ResponseDeletable
    
    var fetcher: Fetcher { get }
    var saver: Saver { get }
    var deleter: Deleter { get }
}
