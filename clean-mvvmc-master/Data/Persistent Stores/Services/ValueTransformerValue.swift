//
//  ValueTransformerValue.swift
//  clean-mvvmc-master
//
//  Created by Developer on 15/10/2023.
//

import Foundation

enum ValueTransformerValue: String {
    
    case user = "UserTransformer"
    case profile = "ProfileTransformer"
    case media = "MediaTransformer"
    case section = "SectionTransformer"
}


extension NSValueTransformerName {
    
    static let user = NSValueTransformerName(rawValue: ValueTransformerValue.user.rawValue)
    
    static let profile = NSValueTransformerName(rawValue: ValueTransformerValue.profile.rawValue)
    
    static let section = NSValueTransformerName(rawValue: ValueTransformerValue.section.rawValue)
    
    static let media = NSValueTransformerName(rawValue: ValueTransformerValue.media.rawValue)
}
