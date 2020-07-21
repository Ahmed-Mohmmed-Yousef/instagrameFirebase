//
//  PhotoSelectorCell.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/21/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let imgv = UIImageView()
        imgv.backgroundColor = .lightGray
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
        return imgv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     
}
