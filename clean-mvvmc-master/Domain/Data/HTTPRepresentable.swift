//
//  HTTPRepresentable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

protocol HTTPRepresentable {
    associatedtype Request: Decodable
    associatedtype Response: Decodable
}
