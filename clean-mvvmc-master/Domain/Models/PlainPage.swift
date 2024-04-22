//
//  PlainPage.swift
//  clean-mvvmc-master
//
//  Created by Developer on 20/04/2024.
//

import Foundation

protocol PlainPageConfigurable {
    var page: Int { get }
    var image: String { get }
    var title: String { get }
    var description: String { get }
}

class PlainPage: Page, PlainPageConfigurable {
    
    var image: String = ""
    var title: String = ""
    var description: String = ""
    
    init(page: Int, image: String, title: String, description: String) {
        super.init()
        self.page = page
        self.image = image
        self.title = title
        self.description = description
    }
}
