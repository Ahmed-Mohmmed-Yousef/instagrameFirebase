//
//  PhotoSelectorController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/21/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Photos

private let reuseCellIdentifier = "cellId"
private let reuseHeaderIdentifier = "headerId"

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemYellow
        
        setupNavButtond()
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        
        // fetch photos
        fetchPhotos()

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
    
    //MARK:- fetch photos
    fileprivate func fetchPhotos(){
        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOption.sortDescriptors = [sortDescriptor]
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOption)
        allPhotos.enumerateObjects { (assest, count, stop) in
            let imageManeger = PHImageManager()
            let targetSize = CGSize(width: 350, height: 350)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManeger.requestImage(for: assest, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                if let image = image {
                    self.images.append(image)
                }
                
                if count == allPhotos.count {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    //MARK:- collection delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! PhotoSelectorCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    //MARK:- CollectionView Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath)
        header.backgroundColor = .red
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
}
