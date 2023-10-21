//
//  Endpoint.swift
//  clean-mvvmc-master
//
//  Created by Developer on 16/09/2023.
//

import Foundation
import CodeBureau

struct Endpoint: Routable {
    
    let method: HTTPMethod
    let path: String
    var isFullPath: Bool = false
    var headerParameters: [String : String] = .jsonContentType
    var queryParametersEncodable: Encodable?
    var queryParameters: [String : Any] = [:]
    var bodyParametersEncodable: Encodable?
    var bodyParameters: [String : Any] = [:]
    var bodyEncoding: BodyEndcoding = .jsonSerializationData
    let responseDecoder = URLResponseDecoder()
}
