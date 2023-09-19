//
//  ValueTransformer.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

private enum ValueTransformerValue: String {
    case user = "UserTransformer"
    case media = "MediaTransformer"
    case section = "SectionTransformer"
}


extension NSValueTransformerName {
    
    static let user = NSValueTransformerName(rawValue: ValueTransformerValue.user.rawValue)
    
    static let section = NSValueTransformerName(rawValue: ValueTransformerValue.section.rawValue)
    
    static let media = NSValueTransformerName(rawValue: ValueTransformerValue.media.rawValue)
}


final class ValueTransformer<T>: NSSecureUnarchiveFromDataTransformer where T: NSObject {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return T.self
    }
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, T.self]
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            fatalError("Unexpected data type, received \(type(of: value)).")
        }
        
        return super.transformedValue(data)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        switch value {
        case let object as T:
            return super.reverseTransformedValue(object)
        case let array as [T]:
            return super.reverseTransformedValue(array)
        default:
            fatalError("Unexpected data type, received \(type(of: value)).")
        }
    }
}
