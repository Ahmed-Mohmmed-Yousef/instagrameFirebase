//
//  User.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/24/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import Foundation
import Firebase
struct User {
    let username: String
    let profileImageURL: String
    
    init(dictionary: [String : Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}

var userCach = [String: User]()
func getUser(uid: String, handler: @escaping(User?, Error?) -> Void) {
    if let user = userCach[uid]{
        handler(user, nil)
        return
    }
    let userRef = Database.database().reference().child("users").child(uid)
    userRef.observeSingleEvent(of: .value, with: { (snapshot) in
        guard let userDic = snapshot.value as? [String: Any] else { return }
        let user = User(dictionary: userDic)
        userCach[uid] = user
        handler(user, nil)
    }) { (error) in
        handler(nil, error)
    }
}
