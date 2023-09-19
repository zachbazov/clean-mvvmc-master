//
//  UserDTO.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

@objc
public final class UserDTO: NSObject, Codable, NSSecureCoding {
    
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
        self._id = coder.decodeObject(
            of: [UserDTO.self, NSString.self],
            forKey: Key.id.rawValue) as? String
        
        self.name = coder.decodeObject(
            of: [UserDTO.self, NSString.self],
            forKey: Key.name.rawValue) as? String
        
        self.email = coder.decodeObject(
            of: [UserDTO.self, NSString.self],
            forKey: Key.email.rawValue) as? String
        
        self.password = coder.decodeObject(
            of: [UserDTO.self, NSString.self],
            forKey: Key.password.rawValue) as? String
        
        self.passwordConfirm = coder.decodeObject(
            of: [UserDTO.self, NSString.self],
            forKey: Key.passwordConfirm.rawValue) as? String
        
        self.role = coder.decodeObject(
            of: [UserDTO.self, NSString.self],
            forKey: Key.role.rawValue) as? String
        
        self.active = coder.decodeObject(
            of: [UserDTO.self, NSNumber.self],
            forKey: Key.active.rawValue) as? Bool
        
        self.token = coder.decodeObject(
            of: [UserDTO.self, NSString.self],
            forKey: Key.token.rawValue) as? String
        
        self.mylist = coder.decodeObject(
            of: [UserDTO.self, NSArray.self, NSString.self],
            forKey: Key.mylist.rawValue) as? [String]
        
        self.profiles = coder.decodeObject(
            of: [UserDTO.self, NSArray.self, NSString.self],
            forKey: Key.profiles.rawValue) as? [String]
        
        self.selectedProfile = coder.decodeObject(
            of: [UserDTO.self, NSString.self],
            forKey: Key.selectedProfile.rawValue) as? String
    }
}

extension UserDTO {
    
    public static var supportsSecureCoding: Bool { true }
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(_id, forKey: Key.id.rawValue)
        coder.encode(name, forKey: Key.name.rawValue)
        coder.encode(email, forKey: Key.email.rawValue)
        coder.encode(password, forKey: Key.password.rawValue)
        coder.encode(passwordConfirm, forKey: Key.passwordConfirm.rawValue)
        coder.encode(role, forKey: Key.role.rawValue)
        coder.encode(active, forKey: Key.active.rawValue)
        coder.encode(token, forKey: Key.token.rawValue)
        coder.encode(mylist, forKey: Key.mylist.rawValue)
        coder.encode(profiles, forKey: Key.profiles.rawValue)
        coder.encode(selectedProfile, forKey: Key.selectedProfile.rawValue)
    }
}


extension UserDTO {
    
    enum Key: String {
        case id = "_id"
        case name
        case email
        case password
        case passwordConfirm
        case role
        case active
        case token
        case mylist
        case profiles
        case selectedProfile
    }
}


extension UserDTO {
    
    func toDomain() -> User {
        return User(
            _id: _id,
            name: name,
            email: email,
            password: password,
            passwordConfirm: passwordConfirm,
            role: role,
            active: active,
            token: token,
            mylist: mylist,
            profiles: profiles,
            selectedProfile: selectedProfile)
    }
}
