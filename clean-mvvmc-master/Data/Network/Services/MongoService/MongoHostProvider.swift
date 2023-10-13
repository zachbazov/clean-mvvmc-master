//
//  MongoHostProvider.swift
//  clean-mvvmc-master
//
//  Created by Developer on 24/09/2023.
//

import Foundation
import MongoDB

struct MongoHostProvider: MongoHostProvidable {
    
    private var host: String {
        guard let host = Bundle.main.object(forInfoDictionaryKey: "API Host") as? String else {
            fatalError("API Host must be set on the property list file.")
        }
        
        return host
    }
    
    private var scheme: String {
        guard let scheme = Bundle.main.object(forInfoDictionaryKey: "API Scheme") as? String else {
            fatalError("API Scheme must be set on the property list file.")
        }
        
        return scheme
    }
    
    
    var absoluteString: String {
        return scheme + "://" + host
    }
}
