//
//  URLResponseDecodable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

protocol URLResponseDecodable {
    
    func decode<T>(_ data: Data) throws -> T where T: Decodable
}
