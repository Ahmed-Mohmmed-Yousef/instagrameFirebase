//
//  UserProfileController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 6/18/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase


private let reuseCellIdentifier = "Cell"
private let reuseHomePostCell = "reuseHomePostCell"
private let reuseHeaderIdentifier = "headerId"

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    
    var posts = [Post]()
    var isFinishPaging = false
    
    private var isGrid = true {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "user profile"
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: reuseHomePostCell)
        self.currentUser()
    }
    
    fileprivate func currentUser(){
        if self.user == nil {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            getUser(uid: uid) { (user, _) in
                self.user = user
                self.fetchUsername()
                self.setupLogOutButton()
                self.paginatePosts()
            }
        } else {
            self.fetchUsername()
            self.setupLogOutButton()
            self.paginatePosts()
        }
        
        
    }

    fileprivate func paginatePosts(){
        
        guard let uid = user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        var query = ref.queryOrderedByKey()
        if posts.count > 0 {
            let value = posts.last?.id
            query = query.queryStarting(atValue: value)
        }
        query.queryLimited(toFirst: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            print("num all objs:",allObjects.count)
            if allObjects.count < 4 {
                self.isFinishPaging = true
            }
            if self.posts.count > 0 {
                allObjects.removeFirst()
            }
            guard let user = self.user else { return }
            allObjects.forEach({ (snap) in
                guard let dic = snap.value as? [String: Any] else { return }
                var post = Post(user: user, dic: dic)
                post.id = snap.key
                self.posts.append(post)
            })
            
            self.collectionView.reloadData()
            
        }) { (error) in
            self.showAlert(message: error.localizedDescription)
        }
    }
    
    
    
    
    fileprivate func fetchOrederedPosts(){
        guard let uid = user?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            
            getUser(uid: uid) { (user, error) in
                guard let user = user else { return }
                let post = Post(user: user, dic: dic)
                self.posts.insert(post, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                
                // complet fetching all user posts
                self.collectionView.insertItems(at: [indexPath])
                
            }
        }) { (error) in
            print("Error in fetchOrderedPosts function: ", error.localizedDescription)
        }
    }
    
    
    private func setupLogOutButton(){
        if user?.uid != Auth.auth().currentUser?.uid { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handelLogOut))
    }
    
    @objc private func handelLogOut(){
        let alertController = UIAlertController(title: "LogOut", message: "Are you surre to log out", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                // go to loginController
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
                
            } catch let signOutError {
                print("Faild to sign out: ", signOutError)
            }
        }))
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    
    private func fetchUsername(){
        self.navigationItem.title = self.user?.username
        self.collectionView.reloadData()
        
    }
    
    private func updateUIData(user: User){
        
    }
    
    //MARK:- CollectionView Delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // paginate
        if indexPath.row == self.posts.count - 1 && !isFinishPaging{
            print("Paginate", isFinishPaging)
            paginatePosts()
        }
        
        if isGrid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseHomePostCell, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGrid {
            let width = view.frame.width / 2 - 0.5
            return CGSize(width: width, height: width)
        } else {
            var height: CGFloat = 40 + 8 + 8 //user profile image height and it`s padding
            height += view.frame.width // cell width
            height += 50 // height of buttons under image
            height += 60 // height of caption text
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    //MARK:~ Header section
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
}


extension UserProfileController: UserProfileHeaderDelegate {
    func didTapGrid() {
        self.isGrid = true
    }
    
    func didTapList() {
        self.isGrid = false
    }
    
}


