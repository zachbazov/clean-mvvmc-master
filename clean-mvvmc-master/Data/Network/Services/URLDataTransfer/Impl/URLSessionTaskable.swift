//
//  URLSessionTaskable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

protocol URLSessionTaskable {
    
    var task: URLSessionTaskCancellable? { get }
}
