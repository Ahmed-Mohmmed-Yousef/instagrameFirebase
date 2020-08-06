//
//  HomeController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/26/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase

fileprivate let cellId  = "cellId"
class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationBarItem()
        
        fetchPosts()
        fetchFollowingUserIds()
    }

    private func setupNavigationBarItem(){
        let iv = UIImageView(image: #imageLiteral(resourceName: "insta"))
        iv.contentMode = .scaleAspectFit
        navigationItem.titleView = iv
    }
    
    fileprivate func fetchFollowingUserIds(){
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("following").child(currentUserId)
        ref.observeSingleEvent(of: .value, with: { (snapsoht) in
            guard let dic = snapsoht.value as? [String: Any] else {return}
            dic.forEach { (key, value) in
                getUser(uid: key) { (user, _) in
                    self.fetchPostsWithUser(user: user!)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        getUser(uid: uid) { (user, error) in
            if let error = error {
                print("faild to get user for post: ", error.localizedDescription)
                return
            }
            
            guard let user = user else { return }
            
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dics = snapshot.value as? [String: Any] else { return }
            dics.forEach { (key, value) in
                guard let dic = value as? [String: Any] else {return}
                let post = Post(user: user, dic: dic)
                self.posts.append(post)
            }
            
            self.posts.sort { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            }
            // complet fetching all user posts
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }) { (error) in
            print("Error :" , error.localizedDescription)
        }
    }
    
    //MARK:- UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 //user profile image height and it`s padding
        height += view.frame.width // cell width
        height += 50 // height of buttons under image
        height += 60 // height of caption text
        return CGSize(width: view.frame.width, height: height)
    }
}
