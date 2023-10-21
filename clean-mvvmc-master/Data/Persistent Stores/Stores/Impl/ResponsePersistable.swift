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
    var deleter: ResponseDeletable { get }
}
