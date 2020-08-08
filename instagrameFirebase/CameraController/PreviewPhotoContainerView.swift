//
//  PreviewPhotoContainerView.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/8/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Photos
class PreviewPhotoContainerView: UIView {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemYellow
        return iv
    }()
    
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.addTarget(self, action: #selector(handelCancel), for: .touchUpInside)
        btn.tintColor = .white
        return btn
    }()
    
    private lazy var saveBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "tray.and.arrow.down"), for: .normal)
        btn.addTarget(self, action: #selector(handelSave), for: .touchUpInside)
        btn.tintColor = .white
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handelCancel(){
        self.removeFromSuperview()
    }
    
    @objc fileprivate func handelSave(){
        guard let previewImage = imageView.image else { return }
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, error) in
            if let error = error {
                print("error during save image:", error.localizedDescription)
                return
            }
            print("savvvvvv")
            self.saveDone()
        }
    }
    
    fileprivate func saveDone(){
        DispatchQueue.main.async {
            let lbl = UILabel()
            lbl.text = "Save Successfully"
            lbl.font = UIFont.boldSystemFont(ofSize: 14)
            lbl.textAlignment = .center
            lbl.textColor = .white
            lbl.backgroundColor = UIColor(white: 0, alpha: 0.5)
            lbl.numberOfLines = 0
            lbl.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
            lbl.center = self.center
            self.addSubview(lbl)
            lbl.layer.transform = CATransform3DMakeScale(0, 0, 0)
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut,
                           animations: {
                            lbl.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }) { (complete) in
                UIView.animate(withDuration: 0.5,
                               delay: 0.75,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseOut,
                               animations: {
                                lbl.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                                lbl.alpha = 0
                }) { (complete) in
                    lbl.removeFromSuperview()
                }
            }
            
        }
    }
    
    fileprivate func setupImageView(){
        addSubview(imageView)
        imageView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor)
    }
    
    fileprivate func setupCancelBtn(){
        addSubview(cancelBtn)
        cancelBtn.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         paddingTop: 16,
                         paddingLeading: 16,
                         width: 50, height: 50)
    }
    
    fileprivate func setupSaveBtn(){
        addSubview(saveBtn)
        saveBtn.anchor(leading: leadingAnchor,
                       bottom: bottomAnchor,
                       paddingLeading: 16,
                       paddingBottom: -32,
                       width: 50, height: 40)
    }
    
    fileprivate func setupUI(){
        setupImageView()
        setupCancelBtn()
        setupSaveBtn()
    }
    
    
}
