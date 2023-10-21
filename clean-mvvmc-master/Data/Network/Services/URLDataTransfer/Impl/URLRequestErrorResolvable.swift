//
//  URLRequestErrorResolvable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

protocol URLRequestErrorResolvable {
    
    func resolve(error: Error) -> URLRequestError
    func resolve(requestError: Error, response: URLResponse?, with data: Data?) -> URLRequestError
}
