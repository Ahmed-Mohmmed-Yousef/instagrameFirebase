//
//  User.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/24/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import Foundation
struct User {
    let username: String
    let profileImageURL: String
    
    init(dictionary: [String : Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}
