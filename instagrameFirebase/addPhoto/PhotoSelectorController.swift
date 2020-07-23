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
    
    //MARK:- properties
    
    var images: [UIImage] = []
    var assests: [PHAsset] = []
    var selectedImage: UIImage?
    var header: PhotoSelectorHeader?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        setupNavButtond()
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        
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
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = self.header?.imageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    //MARK:- fetch photos
    fileprivate func assestFetchOptions() -> PHFetchOptions{
        let fetchOption = PHFetchOptions()
//        fetchOption.fetchLimit = 15
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOption.sortDescriptors = [sortDescriptor]
        return fetchOption
    }
    
    fileprivate func fetchPhotos(){
        
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assestFetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (assest, count, stop) in
                let imageManeger = PHImageManager()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManeger.requestImage(for: assest, targetSize: targetSize, contentMode: .default, options: options) { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assests.append(assest)
                        //to set image in header
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    
                    if count == allPhotos.count-1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                    
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.row]
        self.collectionView.reloadData()
        let index = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: true)
    }
    
    //MARK:- CollectionView Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! PhotoSelectorHeader
        
        self.header = header
        header.imageView.image = self.selectedImage
        
        if let selectedImage = self.selectedImage {
            if let index = images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assests[index]
                let imageManeger = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManeger.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    header.imageView.image = image
                }
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
}
