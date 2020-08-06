//
//  CustomImageView.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/24/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()
var numCall = 0
class CustomImageView: UIImageView {
    
    func loadImage(urlString: String){
        self.image = nil
        if let cachImage = imageCache[urlString] {
            self.image = cachImage
            numCall += 1
//            print("from image cache ", numCall)
            return
        }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error with fetchong image ", error.localizedDescription)
                return
            }
            guard let data = data else { return }
            let image = UIImage(data: data)
            // iamge caching
            imageCache[url.absoluteString] = image
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

