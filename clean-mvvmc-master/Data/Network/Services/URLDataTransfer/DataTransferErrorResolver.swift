//
//  DataTransferErrorResolver.swift
//
//
//  Created by Developer on 23/09/2023.
//

import Foundation
import URLDataTransfer

public struct DataTransferErrorResolver: DataTransferErrorResolvable {
    
    public func resolve(urlRequestError error: URLRequestError) -> DataTransferError {
        let resolvedError = resolve(error: error)
        
        return resolvedError is URLRequestError ? .requestFailure(error) : .resolvedRequestFailure(resolvedError)
    }
    
    
    private func resolve(error: URLRequestError) -> Error {
        let code = URLError.Code(rawValue: (error as NSError).code)
        
        switch code {
        default:
            return error
        }
    }
}
