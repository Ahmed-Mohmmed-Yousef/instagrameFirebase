//
//  CommentCell.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/9/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            textLbl.text = comment.text
            self.photoImageView.loadImage(urlString: comment.user.profileImageURL)
            self.setupAttributedCaption()
            
        }
    }
    
    private var textLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray4
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
        addSubViews(views: textLbl,
                    photoImageView)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttributedCaption() {
        guard let comment = comment else { return }
        let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(comment.text)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        textLbl.attributedText = attributedText
    }
    
    fileprivate func setupTextLbl(){
        textLbl.anchor(top: topAnchor,
                       leading: photoImageView.trailingAnchor,
                       bottom: bottomAnchor,
                       trailing: trailingAnchor,
                       paddingTop: 4,
                       paddingLeading: 4,
                       paddingBottom: -4,
                       paddingTrailing: -4)
    }
    
    fileprivate func setupPhotoImageView(){
        photoImageView.anchor(top: topAnchor,
                              leading: leadingAnchor,
                              paddingTop: 8,
                              paddingLeading: 8,
                              width: 40,
                              height: 40)
        photoImageView.layer.cornerRadius = 40 / 2
        photoImageView.clipsToBounds = true
        
    }
    
    fileprivate func setupUI(){
        setupTextLbl()
        setupPhotoImageView()
    }
}
