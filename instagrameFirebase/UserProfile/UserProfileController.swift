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
private let reuseHeaderIdentifier = "headerId"

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    var posts = [Post]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "user profile"
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        fetchUsername()
        setupLogOutButton()
        
        fetchPosts()
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("posts").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dics = snapshot.value as? [String: Any] else { return }
            dics.forEach { (key, value) in
                guard let dic = value as? [String: Any] else {return}
                let post = Post(dic: dic)
                self.posts.append(post)
            }
            
            // complet fetching all user posts
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }) { (error) in
            print("Error :" , error.localizedDescription)
        }
    }
    
    private func setupLogOutButton(){
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let refrance = Database.database().reference()
        refrance.child("users").child(uid).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            guard let self = self else { return }
            guard let dic = snapshot.value as? [String : Any] else { return }
            self.user = User(dictionary: dic)
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
        }) { (error) in
            print("error accured during fetch user naem: ", error.localizedDescription)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3 - 1
        return CGSize(width: width, height: width)
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
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

}


