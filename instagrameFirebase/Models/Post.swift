//
//  Post.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/24/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import Foundation
//import Firebase

struct Post {
    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date
    
    init(user: User, dic: [String: Any]) {
        self.user = user
        self.imageUrl = dic["imageUrl"] as? String ?? ""
        self.caption = dic["caption"] as? String ?? ""
        
        let secondsFrom1970 = dic["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

func fetchPostWith(user: User){
    
}
