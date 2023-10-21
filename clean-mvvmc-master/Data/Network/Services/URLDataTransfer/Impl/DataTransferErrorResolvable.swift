//
//  DataTransferErrorResolvable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

protocol DataTransferErrorResolvable {
    
    func resolve(urlRequestError error: URLRequestError) -> DataTransferError
}
