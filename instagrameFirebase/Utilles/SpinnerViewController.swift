//
//  SpinnerViewController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/10/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    lazy var spinner = UIActivityIndicatorView(style: .large)
    var text: String?

    override func loadView() {
        view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1322597265, green: 0.1322893202, blue: 0.1322558224, alpha: 0.1469659675)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.layer.cornerRadius = 10.0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        containerView.addSubview(spinner)
        spinner.color = .white
        spinner.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lbl)
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.text = text == nil ? "loading..." : text
        lbl.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 32).isActive = true
        lbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }
}
