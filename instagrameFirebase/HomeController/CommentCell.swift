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
        }
    }
    
    private var textLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemYellow
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupTextLbl(){
        addSubview(textLbl)
        textLbl.anchor(top: topAnchor,
                       leading: leadingAnchor,
                       bottom: bottomAnchor,
                       trailing: trailingAnchor,
                       paddingTop: 4,
                       paddingLeading: 4,
                       paddingBottom: -4,
                       paddingTrailing: -4)
    }
    
    fileprivate func setupUI(){
        setupTextLbl()
    }
}
