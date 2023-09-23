//
//  URLRequestConfiguration.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation
import CodeBureau

struct URLRequestConfiguration: URLRequestConfigurable {
    let baseURL: URL
    let headers: [String: String] = [:]
    let queryParameters: [String: String] = [:]
}
