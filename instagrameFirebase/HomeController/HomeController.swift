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
    
    static let updateFeedNotificationName = Notification.Name("Update Feed")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handelUpdateFeed), name: HomeController.updateFeedNotificationName, object: nil)
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refredshControl = UIRefreshControl()
        refredshControl.addTarget(self, action: #selector(handelRefresh), for: .valueChanged)
        
        collectionView.refreshControl = refredshControl
        setupNavigationBarItem()
        fetchAllPosts()
    }

    private func setupNavigationBarItem(){
        let iv = UIImageView(image: #imageLiteral(resourceName: "insta"))
        iv.contentMode = .scaleAspectFit
        navigationItem.titleView = iv
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc fileprivate func handleCamera(){
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true)
    }
    
    @objc fileprivate func handelUpdateFeed(){
        print("Update Feed notification")
        handelRefresh()
    }
    
    @objc fileprivate func handelRefresh(){
        posts.removeAll()
        self.collectionView.reloadData()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
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
            self.collectionView.refreshControl?.endRefreshing()
            guard let dics = snapshot.value as? [String: Any] else { return }
            dics.forEach { (key, value) in
                guard let dic = value as? [String: Any] else {return}
                var post = Post(user: user, dic: dic)
                post.id = key
                self.posts.append(post)
            }
            
            self.posts.sort { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            }
            // complet fetching all user posts
            self.collectionView.reloadData()
            
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
        cell.delegate = self
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

extension HomeController: HomePostCellDelegate {
    func didTapComment(post: Post) {
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        navigationController?.pushViewController(commentController, animated: true)
    }
}
