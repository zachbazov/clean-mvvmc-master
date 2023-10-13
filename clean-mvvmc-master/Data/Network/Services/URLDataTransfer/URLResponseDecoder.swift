//
//  URLResponseDecoder.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation
import URLDataTransfer

struct URLResponseDecoder {
    
    let json = JSON()
    let rawData = RawData()
    
    
    struct JSON: URLResponseDecodable {
        
        private let decoder = JSONDecoder()
        
        func decode<T>(_ data: Data) throws -> T where T: Decodable {
            return try decoder.decode(T.self, from: data)
        }
    }
    
    
    struct RawData: URLResponseDecodable {
        
        enum CodingKeys: String, CodingKey {
            case `default` = ""
        }
        
        
        func decode<T>(_ data: Data) throws -> T where T: Decodable {
            
            if T.self is Data.Type, let data = data as? T {
                
                return data
                
            } else {
                let context = DecodingError.Context(codingPath: [CodingKeys.default],
                                                    debugDescription: "Expected `Data` type.")
                
                throw DecodingError.typeMismatch(T.self, context)
            }
        }
    }
}
