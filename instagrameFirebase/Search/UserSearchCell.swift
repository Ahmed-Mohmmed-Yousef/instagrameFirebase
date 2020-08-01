//
//  UserSearchCell.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/1/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            usernameLbl.text = user.username
            photo.loadImage(urlString: user.profileImageURL)
        }
    }
    
    private lazy var photo: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemYellow
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Username"
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupPhoto(){
        addSubview(photo)
        photo.anchor(leading: leadingAnchor, paddingLeading: 8, width: 50, height: 50)
        photo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        photo.layer.cornerRadius = 50 / 2
    }
    
    fileprivate func setUseranmeLbl(){
        addSubview(usernameLbl)
        usernameLbl.anchor(top: topAnchor,
                           leading: photo.trailingAnchor,
                           bottom: bottomAnchor,
                           trailing: trailingAnchor,
                           paddingLeading: 8)
    }
    
    fileprivate func setupSeparatorView(){
        let separatorView = UIView()
        addSubview(separatorView)
        separatorView.backgroundColor = .darkGray
        separatorView.anchor(leading: usernameLbl.leadingAnchor,
                             bottom: bottomAnchor,
                             trailing: trailingAnchor,
                             height: 0.5)
    }
    fileprivate func setupUI(){
        setupPhoto()
        setUseranmeLbl()
        setupSeparatorView()
    }
}
