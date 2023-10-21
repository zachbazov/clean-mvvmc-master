//
//  DataTransferError.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

enum DataTransferError: Error {
    
    case noResponse
    case parsing(Error)
    case requestFailure(URLRequestError)
    case resolvedRequestFailure(Error)
}
