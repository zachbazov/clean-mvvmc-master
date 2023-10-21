//
//  ServerHostProvider.swift
//  clean-mvvmc-master
//
//  Created by Developer on 24/09/2023.
//

import Foundation

struct ServerHostProvider: ServerHostProvidable {
    
    private var host: String {
        guard let host = Bundle.main.object(forInfoDictionaryKey: "API Host") as? String else {
            fatalError("API Host must be set in the property-list file and the application's target user-defined properties.")
        }
        
        return host
    }
    
    private var scheme: String {
        guard let scheme = Bundle.main.object(forInfoDictionaryKey: "API Scheme") as? String else {
            fatalError("API Scheme must be set in the property-list file the application's target user-defined properties.")
        }
        
        return scheme
    }
    
    
    var absoluteString: String {
        return scheme + "://" + host
    }
}
