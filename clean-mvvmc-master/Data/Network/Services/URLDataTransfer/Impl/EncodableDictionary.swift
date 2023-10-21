//
//  EncodableDictionary.swift
//  clean-mvvmc-master
//
//  Created by Developer on 23/09/2023.
//

import Foundation

extension Encodable {
    
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data)
        
        return json as? [String: Any]
    }
}


extension Dictionary {
    
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

extension Dictionary where Key == String, Value == String {
    
    static var jsonContentType: [String: String] {
        return ["content-type": "application/json"]
    }
    
    
    mutating func setHeader(_ key: String, _ value: String) {
        self[key] = value
    }
    
    mutating func removeHeader(_ key: String) {
        self.removeValue(forKey: key)
    }
}
