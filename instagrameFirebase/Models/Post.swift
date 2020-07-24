//
//  Post.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/24/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init(dic: [String: Any]) {
        self.imageUrl = dic["imageUrl"] as? String ?? ""
    }
}
