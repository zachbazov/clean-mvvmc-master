//
//  PathIndexable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/10/2023.
//

import Foundation

@objc
protocol PathIndexable {
    
    @objc optional var indexPath: IndexPath? { get }
}
