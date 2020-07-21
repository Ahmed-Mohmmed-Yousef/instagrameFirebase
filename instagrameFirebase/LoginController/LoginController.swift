//
//  LoginController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 7/19/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    private var logoImageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "insta"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.backgroundColor = UIColor(white: 0, alpha: 0.03)
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 14)
        field.addTarget(self, action: #selector(handelTextInputChange), for: .editingChanged)
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password"
        field.backgroundColor = UIColor(white: 0, alpha: 0.03)
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 14)
        field.addTarget(self, action: #selector(handelTextInputChange), for: .editingChanged)
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        return field
    }()
    
    private lazy var signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign in", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        return btn
    }()
    
    private var signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        let attrributed = NSMutableAttributedString(string: "Dont have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attrributed.append(NSAttributedString(string: "SIGNUP", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        btn.setAttributedTitle(attrributed, for: .normal)
        btn.addTarget(self, action: #selector(handelSignUp), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true 
        title = "Login"
        
        addViews()
        setupUI()
    }
    
    private func addViews(){
        view.addSubViews(views: logoImageView,
                         emailField,
                         passwordField,
                         signInButton,
                         signUpButton)
    }
    
    @objc private func signInTapped(){
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to sign in with email: ", error.localizedDescription)
                return
            }
            
            print("Successfully logged back in with user id: ", result?.user.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBar else { return }
            mainTabBarController.setViewControllers()
            self.dismiss(animated: true )
        }
        
    }
    
    @objc private func handelTextInputChange(){
        let isValid = !emailField.text!.isEmpty &&
            !(passwordField.text?.isEmpty ?? false)
        signInButton.isEnabled = isValid
        signInButton.backgroundColor = isValid ? UIColor.rgb(red: 117, green: 154, blue: 237) : UIColor.rgb(red: 149, green: 204, blue: 244)
    }

    
    @objc private func handelSignUp(){
        let signUpController = SignUpViewController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    
    private func setupLogoImageView(){
        logoImageView.anchor(top: view.layoutMarginsGuide.topAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             height: 200)
    }
    
    private func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailField,
                                                       passwordField,
                                                       signInButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        
        stackView.anchor(top: logoImageView.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         paddingTop: 20,
                         paddingLeading: 40,
                         paddingBottom: 0,
                         paddingTrailing: -40,
                         width: 0,
                         height: 160)
    }
    
    
    private func setupSignUpBtn(){
        signUpButton.anchor(leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor,
                         height: 50.0)
    }
    
    private func setupUI(){
        setupSignUpBtn()
        setupLogoImageView()
        setupInputFields()
    }
    

}
