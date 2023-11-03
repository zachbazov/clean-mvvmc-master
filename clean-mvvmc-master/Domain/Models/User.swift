//
//  User.swift
//  clean-mvvmc-master
//
//  Created by Developer on 17/09/2023.
//

import Foundation

struct User {
    
    var _id: String?
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirm: String?
    var role: String?
    var active: Bool?
    var token: String?
    var mylist: String?
    var profiles: [String]?
    var selectedProfile: String?
}


extension User {
    
    func toDTO() -> UserDTO {
        return UserDTO(
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
