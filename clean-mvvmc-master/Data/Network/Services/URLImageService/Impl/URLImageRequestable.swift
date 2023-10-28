//
//  URLImageRequestable.swift
//  clean-mvvmc-master
//
//  Created by Developer on 22/10/2023.
//

import UIKit

protocol URLImageRequestable {
    
    func load(url: URL, identifier: NSString, completion: ((UIImage?) -> Void)?)
}
