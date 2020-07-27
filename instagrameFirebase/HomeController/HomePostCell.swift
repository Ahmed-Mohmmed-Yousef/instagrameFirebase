//
//  HomePostCell.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/26/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
var numHomePostCell = 0
class HomePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else {return}
            photoIamgeView.loadImage(urlString: imageUrl)
        }
    }
    
    lazy var photoIamgeView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .green
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews(views: photoIamgeView)
        setupUI()
        numHomePostCell += 1
        print(numHomePostCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhotoImageView(){
        photoIamgeView.anchor(top: topAnchor,
                              leading: leadingAnchor,
                              bottom: bottomAnchor,
                              trailing: trailingAnchor)
    }
    
    
    private func setupUI(){
        setupPhotoImageView()
    }
}
