//
//  UserProfileHeader.swift
//  instagrameFirebase
//
//  Created by Ahmed on 6/19/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let profileImageURL = user?.profileImageURL else { return }
            fetchUserProfileImage(urlString: profileImageURL)
            usernameLbl.text = user?.username
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGreen
        iv.layer.cornerRadius = 80 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "username"
        lbl.font = .boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    private lazy var gridButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "square.grid.3x2.fill"), for: .normal)
        
        return btn
    }()
    
    private lazy var listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "rectangle.grid.1x2"), for: .normal)
        btn.tintColor = .init(white: 0, alpha: 0.2)
        return btn
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        btn.tintColor = .init(white: 0, alpha: 0.2)
        return btn
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var postLbl: UILabel = {
        let lbl = UILabel()
        let atributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        atributedText.append(NSAttributedString(string: "pasts",
                                                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                                                             NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        lbl.attributedText = atributedText
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private lazy var followersLbl: UILabel = {
        let lbl = UILabel()
        let atributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        atributedText.append(NSAttributedString(string: "followers",
                                                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                                                             NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        lbl.attributedText = atributedText
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private lazy var followingLbl: UILabel = {
        let lbl = UILabel()
        let atributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        atributedText.append(NSAttributedString(string: "following",
                                                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                                                             NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        lbl.attributedText = atributedText
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        layoutUI()
    }
    
    private lazy var editProfileButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchUserProfileImage(urlString: String){
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error with fetchong profile image ", error.localizedDescription)
                return
            }
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }.resume()
    }
    
    private func addViews(){
        addSubViews(views: profileImageView,
                    usernameLbl,
                    gridButton,
                    listButton,
                    bookmarkButton,
                    stack,
                    postLbl,
                    followersLbl,
                    followingLbl,
                    editProfileButton)
    }
    
    private func setupUserProfileImageView(){
        profileImageView.anchor(top: topAnchor,
                                leading: leadingAnchor,
                                paddingTop: 12,
                                paddingLeading: 12,
                                width: 80,
                                height: 80)
    }
    
    private func setupUsernameLbl(){
        usernameLbl.anchor(top: profileImageView.bottomAnchor,
                           paddingTop: 12)
        usernameLbl.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
    }
    
    private func setupHeaderButtons(){
        let stack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        
        addSubview(stack)
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        stack.anchor(leading: leadingAnchor,
                     bottom: bottomAnchor,
                     trailing: trailingAnchor,
                    height: 50)
        
        topDivider.anchor(top: stack.topAnchor,
                          leading: stack.leadingAnchor,
                          trailing: stack.trailingAnchor,
                          height: 1)
        bottomDivider.anchor(top: stack.bottomAnchor,
                             leading: stack.leadingAnchor,
                             trailing: stack.trailingAnchor,
                             height: 1)
    }
    
    private func setupUserStatsView(){
        stack.addArrangedSubview(postLbl)
        stack.addArrangedSubview(followersLbl)
        stack.addArrangedSubview(followingLbl)
        
        stack.anchor(top: topAnchor,
                     leading: profileImageView.trailingAnchor,
                     trailing: trailingAnchor,
                     paddingTop: 12,
                     paddingLeading: 12,
                     paddingTrailing: -12,
                     height: 50)
    }
    
    private func setupEditProfileButton(){
        editProfileButton.anchor(top: stack.bottomAnchor,
                                 leading: profileImageView.trailingAnchor,
                                 trailing: trailingAnchor,
                                 paddingTop: 4,
                                 paddingLeading: 12,
                                 paddingTrailing: -12,
                                 height: 40)
    }
    
    private func layoutUI(){
        setupUserProfileImageView()
        setupUsernameLbl()
        setupHeaderButtons()
        setupUserStatsView()
        setupEditProfileButton()
        
    }
}
