//
//  Comment.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/9/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import Foundation
struct Comment {
    let id: String
    let uid: String
    let text: String
    let creationDate: Date
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.uid = dictionary["uid"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
