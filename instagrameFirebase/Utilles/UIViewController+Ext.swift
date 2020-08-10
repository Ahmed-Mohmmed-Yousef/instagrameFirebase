//
//  UIViewController+Ext.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/9/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//
import UIKit

extension UIViewController {
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Alert",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok",
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        self.present(alert,
                     animated: true,
                     completion: nil)
        
    }
    
}

