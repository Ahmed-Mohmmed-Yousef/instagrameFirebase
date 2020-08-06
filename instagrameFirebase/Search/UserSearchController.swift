//
//  UserSearchController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/1/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private let cellId = "cellId"
    private var users = [User]()
    private var resultUsers = [User]()
    
    private lazy var seachBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.tintColor = .gray
        UITextView.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        setupUI()
        fetchUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        seachBar.isHidden = false
    }
    
    fileprivate func fetchUsers(){
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dics = snapshot.value as? [String: Any] else { return }
            dics.forEach { (key, value) in
                if key == Auth.auth().currentUser?.uid {
                    print("find my self")
                    return
                }
                guard let userDic = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDic)
                self.users.append(user)
            }
            self.users.sort { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            }
            self.collectionView.reloadData()
            
        }) { (error) in
            print("faild to fetch user for search: ", error.localizedDescription)
        }
    }
    
    fileprivate func setupSearchBar(){
        navigationController?.navigationBar.addSubview(seachBar)
        let navBar = navigationController?.navigationBar
        seachBar.anchor(top: navBar?.topAnchor,
                        leading: navBar?.leadingAnchor,
                        bottom: navBar?.bottomAnchor,
                        trailing: navBar?.trailingAnchor,
                        paddingLeading: 8,
                        paddingTrailing: -8)
    }
    
    fileprivate func setupUI(){
        setupSearchBar()
    }
    
    //MARK:- UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultUsers = users.filter({ (user) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
    
    //MARK:- UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seachBar.text?.isEmpty ?? true ? users.count : resultUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = seachBar.text?.isEmpty ?? true ? users[indexPath.row] : resultUsers[indexPath.row]
        return cell
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seachBar.isHidden = true
        seachBar.resignFirstResponder()
        let selectedUser = seachBar.text?.isEmpty ?? true ? users[indexPath.row] : resultUsers[indexPath.row]
        let selectedUserPrfile = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        selectedUserPrfile.user = selectedUser
        navigationController?.pushViewController(selectedUserPrfile, animated: true)
    }
}

