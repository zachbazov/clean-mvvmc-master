//
//  Page.swift
//  clean-mvvmc-master
//
//  Created by Developer on 20/04/2024.
//

import Foundation

protocol Pagable {
    var page: Int { get }
}

class Page {
    var page: Int = -1
}

extension Page: Pagable {}
