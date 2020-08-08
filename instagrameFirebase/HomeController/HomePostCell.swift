//
//  HomePostCell.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/26/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
}


var numHomePostCell = 0
class HomePostCell: UICollectionViewCell {
    
    var delegate: HomePostCellDelegate?
    var post: Post? {
        didSet {
            guard let post = post else {return}
            photoIamgeView.loadImage(urlString: post.imageUrl)
            usernameLabel.text = post.user.username
//            captionLabel.text = post.caption
            setupAttributedCaption()
            userProfileImageView.loadImage(urlString: post.user.profileImageURL)
        }
    }
    
    lazy var userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = UIImage(systemName: "person")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "username"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    lazy var photoIamgeView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .systemGreen
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var optionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    lazy var likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal),
                     for: .normal)
        return btn
    }()
    
    lazy var commentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bubble.right")?.withRenderingMode(.alwaysOriginal),
                     for: .normal)
        btn.addTarget(self, action: #selector(handelComment), for: .touchUpInside)
        return btn
    }()
    
    lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysOriginal),
                     for: .normal)
        return btn
    }()
    
    lazy var bookMarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysOriginal),
                     for: .normal)
        return btn
    }()
    
    lazy var captionLabel: UILabel = {
        let lbl = UILabel()
        let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " some caption text that appear under image of the post", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "1week ago", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray]))
        lbl.attributedText = attributedText
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(views: userProfileImageView,
                    usernameLabel,
                    photoIamgeView,
                    optionButton,
                    captionLabel)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handelComment(){
        guard let post = self.post else { return }
        delegate?.didTapComment(post: post)
    }
    
    private func setupAttributedCaption() {
        guard let post = post else {
            return
        }
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: self.post!.creationDate, relativeTo: Date())
        
        attributedText.append(NSAttributedString(string: relativeDate , attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray]))
        captionLabel.attributedText = attributedText
    }
    
    //MARK:- setup UI
    private func setupUserProfileIamgeView(){
        userProfileImageView.anchor(top: topAnchor,
                                    leading: leadingAnchor,
                                    paddingTop: 8,
                                    paddingLeading: 8,
                                    width: 40,
                                    height: 40)
        userProfileImageView.layer.cornerRadius = 40/2
    }
    
    private func setupUserNameLable(){
        usernameLabel.anchor(top: topAnchor,
                             leading: userProfileImageView.trailingAnchor,
                             bottom: photoIamgeView.topAnchor,
                             trailing: optionButton.leadingAnchor,
                             paddingTop: 8,
                             paddingLeading: 8,
                             paddingBottom: -8)
    }
    
    private func setupPhotoImageView(){
        photoIamgeView.anchor(top: userProfileImageView.bottomAnchor,
                              leading: leadingAnchor,
                              trailing: trailingAnchor,
                              paddingTop: 8)
        photoIamgeView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    }
    
    private func setupOptionButton(){
        optionButton.anchor(top: topAnchor,
                            bottom: photoIamgeView.topAnchor,
                            trailing: trailingAnchor,
                            width: 44)
    }
    
    private func setupActionButton(){
        let stack = UIStackView(arrangedSubviews: [likeButton, commentButton, sendButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        addSubview(stack)
        
        stack.anchor(top: photoIamgeView.bottomAnchor,
                     leading: leadingAnchor,
                     paddingLeading: 8,
                     width: 120,
                     height: 50)
        addSubview(bookMarkButton)
        bookMarkButton.anchor(top: photoIamgeView.bottomAnchor,
                              trailing: trailingAnchor,
                              paddingTrailing: -8,
                              width: 40,
                              height: 50)
    }
    
    private func setupCaptionLabel(){
        captionLabel.anchor(top: likeButton.bottomAnchor,
                            leading: leadingAnchor,
                            bottom: bottomAnchor,
                            trailing: trailingAnchor,
                            paddingLeading: 8,
                            paddingTrailing: -8)
    }
    
    
    private func setupUI(){
        setupUserProfileIamgeView()
        setupUserNameLable()
        setupPhotoImageView()
        setupOptionButton()
        setupActionButton()
        setupCaptionLabel()
        
    }
}
