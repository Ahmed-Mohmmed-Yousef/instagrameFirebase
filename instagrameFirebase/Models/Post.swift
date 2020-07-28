//
//  Post.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/24/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import Foundation

struct Post {
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dic: [String: Any]) {
        self.user = user
        self.imageUrl = dic["imageUrl"] as? String ?? ""
        self.caption = dic["caption"] as? String ?? ""
    }
}
