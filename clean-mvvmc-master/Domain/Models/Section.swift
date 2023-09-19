//
//  Section.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

protocol SectionRepresentable {
    var id: Int? { get }
    var title: String? { get }
    var media: [Media]? { get }
}


struct Section: SectionRepresentable {
    
    var id: Int?
    var title: String?
    var media: [Media]?
}


extension Section {
    
    static var vacantValue: Section {
        return Section()
    }
}
