//
//  Reusable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/10/2023.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
