//
//  URLRequestError.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

enum URLRequestError: Error {
    
    case error(statusCode: Int, data: Data?)
    case noInternetConnection
    case noServerConnection
    case cancelled
    case generic(Error)
    case urlGeneration
    
    
    var alteredDescription: String {
        switch self {
        case .error(let statusCode, _):
            return "Error status code: \(statusCode)."
        case .noInternetConnection:
            return "Could not connect to the internet."
        case .noServerConnection:
            return "Could not connect to the server."
        case .cancelled:
            return "Operation was cancelled."
        case .generic(let error):
            return error.localizedDescription
        case .urlGeneration:
            return "Could not generate the provided url."
        }
    }
}
