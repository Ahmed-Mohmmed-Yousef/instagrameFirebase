//
//  SharePhotoController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/23/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    private lazy var spinner: SpinnerViewController = {
        let indic = SpinnerViewController()
        indic.modalPresentationStyle = .overCurrentContext
        return indic
    }()
    
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
        self.showSpinner()
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        let fileName = UUID().uuidString
        let referance = Storage.storage().reference().child("posts").child(fileName)
        referance.putData(uploadData, metadata: nil) { (metaData, error) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.removeSpinner {
                    self.showAlert(message: error.localizedDescription)
                }
                return
            }
            
            referance.downloadURL { (url, error) in
                guard let imageURL = url?.absoluteString else { return }
                print("image url : ", imageURL)
                self.saveToDatabaseWithImageUrl(imageUrl: imageURL)
            }
        }
    }
    
    private func saveToDatabaseWithImageUrl(imageUrl: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let caption = textView.text else { return }
        guard let postImage = selectedImage else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values: [String: Any] = ["imageUrl" : imageUrl,
                      "caption" : caption,
                      "imageWidth": postImage.size.width,
                      "imageHeight": postImage.size.height,
                      "creationDate": Date().timeIntervalSince1970]
        
        ref.updateChildValues(values) { (error, referance) in
            if let error = error {
                self.removeSpinner {
                    self.showAlert(message: error.localizedDescription)
                }
                return
            }
            
            self.removeSpinner {
                self.dismiss(animated: true)
                 NotificationCenter.default.post(name: HomeController.updateFeedNotificationName, object: nil )
            }
           
        }
    }
    
    //MARK:- UI function
    fileprivate func setupImageAndTextView(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.layoutMarginsGuide.topAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             paddingTop: 8,
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
    
    //MARK:- Spinner func
    fileprivate func showSpinner(){
        view.endEditing(true)
        self.present(spinner, animated: true)
    }
    
    fileprivate func removeSpinner(completion: (()-> Void)? = nil){
        self.spinner.dismiss(animated: true, completion: completion)
    }

}
