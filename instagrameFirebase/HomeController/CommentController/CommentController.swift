//
//  CommentController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/8/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase

protocol CommentInputAccessoryViewDelegate {
    func handelSubmit(text: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    private lazy var submitBtn: UIButton = {
        let submitBtn = UIButton(type: .system)
        submitBtn.addTarget(self, action: #selector(handelSubmit), for: .touchUpInside)
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.setTitleColor(.black, for: .normal)
        submitBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return submitBtn
    }()
    
     lazy var textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.text = "type here"
        tv.font = UIFont.systemFont(ofSize: 18)
//        tv.contentMode =
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        addSubview(submitBtn)
        addSubview(textView)
        setupSubmitBtn()
        setupTextFiled()
        setupLineSperatorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    @objc fileprivate func handelSubmit(){
        self.textView.resignFirstResponder()
        if let text = textView.text, !text.isEmpty{
            delegate?.handelSubmit(text: text)
        }
        
    }
    
    fileprivate func setupSubmitBtn(){
        submitBtn.anchor(top: topAnchor,
                         trailing: trailingAnchor,
                         paddingTrailing: -12,
                         width: 50,
                         height: 50)
    }
    
    fileprivate func setupTextFiled(){
        textView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: safeAreaLayoutGuide.bottomAnchor,
                         trailing: submitBtn.leadingAnchor,
                         paddingTop: 8,
                         paddingLeading: 12,
                         paddingBottom: -8,
                         paddingTrailing: -8)
    }
    
    fileprivate func setupLineSperatorView(){
        let lineSperatorView = UIView()
        addSubview(lineSperatorView)
        lineSperatorView.backgroundColor = .rgb(red: 230, green: 230, blue: 230)
        lineSperatorView.anchor(top: topAnchor,
                                leading: leadingAnchor,
                                trailing: trailingAnchor,
                                height: 0.5)
    }
}


private let reuseIdentifier = "CommentCell"

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var post: Post?
    var comments = [Comment]()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        textField.returnKeyType = .done
        //        textField.delegate = self
        return textField
    }()
    
    lazy var containerView: CommentInputAccessoryView = {
        let containerView = CommentInputAccessoryView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 50, height: 90)
        containerView.delegate = self
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comment"
        self.collectionView!.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
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
    
    
    
    //MARK:- Fetch comment
    fileprivate func fetchComment() {
        guard let postId = post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            guard let dic = snapshot.value as? [String: Any] else { return }
            guard let uid = dic["uid"] as? String else { return }
            getUser(uid: uid) { (user, _) in
                guard let user = user else { return }
                let comment = Comment(id: id, user: user, dictionary: dic)
                self.comments.append(comment)
                let indexPath = IndexPath(row: self.comments.count - 1, section: 0)
                self.collectionView.insertItems(at: [indexPath])
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
            
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
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.row]
        dummyCell.layoutIfNeeded()
        let target = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(target)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension CommentController: CommentInputAccessoryViewDelegate{
    func handelSubmit(text: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post?.id else { return }
        
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
            self.containerView.textView.text = ""
        }
    }
}


