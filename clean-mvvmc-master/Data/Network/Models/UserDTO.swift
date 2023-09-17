//
//  UserDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

@objc
final class UserDTO: NSObject {
    
    var _id: String?
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirm: String?
    var role: String?
    var active: Bool?
    var token: String?
    var mylist: [String]?
    var profiles: [String]?
    var selectedProfile: String?
    
    
    init(_id: String? = nil,
         name: String? = nil,
         email: String? = nil,
         password: String? = nil,
         passwordConfirm: String? = nil,
         role: String? = nil,
         active: Bool? = nil,
         token: String? = nil,
         mylist: [String]? = [],
         profiles: [String]? = [],
         selectedProfile: String? = nil) {
        self._id = _id
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirm = passwordConfirm
        self.role = role
        self.active = active
        self.token = token
        self.mylist = mylist
        self.profiles = profiles
        self.selectedProfile = selectedProfile
    }
    
    public required init?(coder: NSCoder) {
        self._id = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "_id") as? String
        self.name = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "name") as? String
        self.email = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "email") as? String
        self.password = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "password") as? String
        self.passwordConfirm = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "passwordConfirm") as? String
        self.role = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "role") as? String
        self.active = coder.decodeObject(of: [UserDTO.self, NSNumber.self], forKey: "active") as? Bool
        self.token = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "token") as? String
        self.mylist = coder.decodeObject(of: [UserDTO.self, NSArray.self, NSString.self], forKey: "mylist") as? [String]
        self.profiles = coder.decodeObject(of: [UserDTO.self, NSArray.self, NSString.self], forKey: "profiles") as? [String]
        self.selectedProfile = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "selectedProfile") as? String
    }
}

extension UserDTO: Codable, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool { true }
    
    public func encode(with coder: NSCoder) {
        coder.encode(_id, forKey: "_id")
        coder.encode(name, forKey: "name")
        coder.encode(email, forKey: "email")
        coder.encode(password, forKey: "password")
        coder.encode(passwordConfirm, forKey: "passwordConfirm")
        coder.encode(role, forKey: "role")
        coder.encode(active, forKey: "active")
        coder.encode(token, forKey: "token")
        coder.encode(mylist, forKey: "mylist")
        coder.encode(profiles, forKey: "profiles")
        coder.encode(selectedProfile, forKey: "selectedProfile")
    }
}
