//
//  PhotoSelectorController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/21/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoSelectorController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemYellow
        
        setupNavButtond()

    }

    fileprivate func setupNavButtond(){
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handelCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handelNext))
    }
    
    @objc fileprivate func handelCancel(){
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func handelNext(){
        print("next")
    }
}
