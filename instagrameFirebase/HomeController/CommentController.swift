//
//  CommentController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/8/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "CommentCell"

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var post: Post?
    var comments = [Comment]()
    
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
        
        navigationItem.title = "Comment"
        self.collectionView!.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemRed
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        fetchComment()
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
        }
    }
    
    //MARK:- Fetch comment
    fileprivate func fetchComment() {
        guard let postId = post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            guard let dic = snapshot.value as? [String: Any] else { return }
            let comment = Comment(id: id, dictionary: dic)
            self.comments.append(comment)
            let indexPath = IndexPath(row: self.comments.count - 1, section: 0)
            self.collectionView.insertItems(at: [indexPath])
        }) { (error) in
            self.showAlert(message: error.localizedDescription)
        }
    }
    
    //MARK:- CollectionView delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    
    //MARK:- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}



extension CommentController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.handelSubmit()
        return true
    }
}
