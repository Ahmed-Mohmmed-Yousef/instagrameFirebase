//
//  SharePhotoController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/23/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage?{
        didSet {
            imageView.image = selectedImage
        }
    }
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handelShare))
        setupImageAndTextView()

    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @objc private func handelShare(){
        print("Hi")
    }
    
    fileprivate func setupImageAndTextView(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.layoutMarginsGuide.topAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor,
                         leading: containerView.leadingAnchor,
                         bottom: containerView.bottomAnchor,
                         paddingTop: 8,
                         paddingLeading: 8,
                         paddingBottom: -8,
                         width: 84)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor,
                        leading: imageView.trailingAnchor,
                        bottom: containerView.bottomAnchor,
                        trailing: containerView.trailingAnchor,
                        paddingTop: 8,
                        paddingLeading: 8,
                        paddingBottom: -4,
                        paddingTrailing: -4)
        
    }

}
