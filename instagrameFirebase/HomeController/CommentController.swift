//
//  CommentController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/8/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class CommentController: UICollectionViewController {
    
    var post: Post?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        textField.keyboardType = .alphabet
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitBtn = UIButton(type: .system)
        submitBtn.addTarget(self, action: #selector(handelSubmit), for: .touchUpInside)
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.setTitleColor(.black, for: .normal)
        submitBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        containerView.addSubview(submitBtn)
        submitBtn.anchor(top: containerView.topAnchor,
                         bottom: containerView.bottomAnchor,
                         trailing: containerView.trailingAnchor,
                         paddingTrailing: -12,
                         width: 50)
        
        
        containerView.addSubview(textField)
        textField.anchor(top: containerView.topAnchor,
                         leading: containerView.leadingAnchor,
                         bottom: containerView.bottomAnchor,
                         trailing: submitBtn.leadingAnchor,
                         paddingLeading: 12,
                         paddingTrailing: -8)
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemRed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    @objc fileprivate func handelSubmit(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post?.id else { return }
        guard let text = textField.text, !text.isEmpty else {
            self.textField.resignFirstResponder()
            return
        }
        let date = Date().timeIntervalSince1970
        let value: [String : Any] = ["uid": uid,
                                     "creationDate": date,
                                     "text": text]
        
        let ref = Database.database().reference().child("comments").child(postId).childByAutoId()
        ref.updateChildValues(value) { (error, ref) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            
            self.textField.text = ""
            self.textField.resignFirstResponder()
            print("comment success")
        }
        
        
    }
    
}

extension CommentController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.handelSubmit()
        return true
    }
}
