//
//  CommentController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/8/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CommentController: UICollectionViewController {
    
    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemRed
        print(post?.caption)
    }

    
}
