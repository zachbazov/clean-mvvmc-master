//
//  SectionDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import Foundation

@objc
public final class SectionDTO: NSObject, Codable, NSSecureCoding {
    
    let id: Int
    let title: String
    var media: [MediaDTO]
    
    
    init(id: Int, title: String, media: [MediaDTO]) {
        self.id = id
        self.title = title
        self.media = media
    }
    
    public init?(coder: NSCoder) {
        self.id = coder.decodeInteger(forKey: "id")
        self.title = coder.decodeObject(of: NSString.self, forKey: "title") as? String ?? ""
        self.media = coder.decodeObject(of: [NSArray.self, MediaDTO.self], forKey: "media") as? [MediaDTO] ?? []
    }
}


extension SectionDTO {
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(media, forKey: "media")
    }
}


extension SectionDTO {
    
    func toDomain() -> Section {
        return Section(id: id,
                       title: title,
                       media: media.map { $0.toDomain() })
    }
}


extension Array where Element == SectionDTO {
    
    func toDomain() -> [Section] {
        return map { $0.toDomain() }
    }
}
