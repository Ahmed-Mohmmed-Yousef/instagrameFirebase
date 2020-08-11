//
//  MainTabBar.swift
//  instagrameFirebase
//
//  Created by Ahmed on 6/18/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase

class MainTabBar: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
            return false
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }
            return
        }
        
        setViewControllers()
    }
    
    func setViewControllers(){
        //Home
        let homeController = templetNavController(image: UIImage(systemName: "house")!, selectedImage: UIImage(systemName: "house.fill")!, rooteViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
       
        
        //Search
        let searchController = templetNavController(image: UIImage(systemName: "magnifyingglass")!, selectedImage: UIImage(systemName: "magnifyingglass")!,rooteViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //plus
        let plusController = templetNavController(image: UIImage(systemName: "plus.square")!, selectedImage: UIImage(systemName: "plus.square.fill")!)
        
        //like
        let likeController = templetNavController(image: UIImage(systemName: "heart")!, selectedImage: UIImage(systemName: "heart.fill")!)
        
        
        // User profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let userProfileNavController = templetNavController(image: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person.fill")!, rooteViewController: userProfileController)
        
        tabBar.tintColor = .black
        viewControllers = [homeController,
                           searchController,
                           plusController,
                           likeController,
                           userProfileNavController]
        
        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 14,
                                                left: 0,
                                                bottom: -4,
                                                right: 0)
            }
        }
    }
    
    fileprivate func templetNavController(image: UIImage, selectedImage: UIImage, rooteViewController: UIViewController = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rooteViewController)
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
