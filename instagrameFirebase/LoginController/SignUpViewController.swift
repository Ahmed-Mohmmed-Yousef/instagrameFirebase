//
//  ViewController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 6/15/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    private lazy var plusPhotoImge: UIImageView = {
        let imgView = UIImageView(image: UIImage(systemName: "person.crop.square.fill"))
        imgView.tintColor = .systemBlue
        imgView.contentMode = .scaleAspectFit
        imgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoDidTapped))
        imgView.addGestureRecognizer(tap)
        
        imgView.layer.cornerRadius = 20
        imgView.layer.masksToBounds = true
        imgView.layer.borderColor = UIColor.gray.cgColor
        imgView.layer.borderWidth = 2
        return imgView
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
    
    private lazy var usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
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
    
    
    private lazy var signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return btn
    }()
    
    
    private var signInBtn: UIButton = {
        let btn = UIButton(type: .system)
        let attrributed = NSMutableAttributedString(string: "Already have an account ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attrributed.append(NSAttributedString(string: "SIGNIN", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        btn.setAttributedTitle(attrributed, for: .normal)
        btn.addTarget(self, action: #selector(handelSignIn), for: .touchUpInside)
        return btn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        layoutUI()
    }
    
    private func addViews(){
        view.addSubViews(views: plusPhotoImge,
                         emailField,
                         usernameField,
                         passwordField,
                         signUpButton,
                         signInBtn)
    }
    
    @objc private func handelTextInputChange(){
        let isValid = !emailField.text!.isEmpty &&
            !(usernameField.text?.isEmpty ?? false) &&
            !(passwordField.text?.isEmpty ?? false)
        signUpButton.isEnabled = isValid
        signUpButton.backgroundColor = isValid ? UIColor.rgb(red: 117, green: 154, blue: 237) : UIColor.rgb(red: 149, green: 204, blue: 244)
    }
    
    @objc private func handelSignIn(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func signUpTapped(){
        guard let email = emailField.text, !email.isEmpty else { return }
        guard let password = passwordField.text, !password.isEmpty else { return }
        guard let username = usernameField.text, !username.isEmpty else { return }
        guard let img = plusPhotoImge.image else { return }
        
        /// create new account
        Auth.auth().createUser(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                print("Fields to create new account: \(error.localizedDescription)")
                return
            }
            guard let uid = auth?.user.uid else { return }
            guard let uploadData = img.pngData() else {
                print("Cant get the image")
                return
            }
            print("create new account Success")
            /// upload the profile picture
            let referance = Storage.storage().reference().child("images/\(uid)_profile_picture.png")
            referance.putData(uploadData, metadata: nil) { (metaData, error) in
                if let error = error {
                    print("Fields to upload profile picture: \(error.localizedDescription)")
                    return
                }
                referance.downloadURL { (url, error) in
                    guard let url = url?.absoluteString, error == nil else {
                        print("Cant get profile picture URL: \(error!.localizedDescription)")
                        return
                    }
                    print("Success Upload profile picture to Storage url: \(url)")
                    
                    let usernameValue = ["username": username, "profileImageURL": url]
                    let value = [uid: usernameValue]
                    
                    /// save user info in firebase database
                    Database.database().reference().child("users").updateChildValues(value) { (error, referance) in
                        if error != nil {
                            print("Fiald to save user info to db")
                            return
                        }
                        
                        print("Success save user info to db")
                        
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBar else { return }
                        mainTabBarController.setViewControllers()
                        self.dismiss(animated: true )
                    }
                }
                
            }
            
            
            
        }
    }
    
    @objc private func photoDidTapped(){
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        pickerVC.allowsEditing = true
        present(pickerVC, animated: true)
    }


    private func setupPlusPhoto(){
        plusPhotoImge.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             paddingTop: 40,
                             width: 140,
                             height: 140)
        
        NSLayoutConstraint.activate([
            plusPhotoImge.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailField,
                                                       usernameField,
                                                       passwordField,
                                                       signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        
        stackView.anchor(top: plusPhotoImge.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         paddingTop: 20,
                         paddingLeading: 40,
                         paddingBottom: 0,
                         paddingTrailing: -40,
                         width: 0,
                         height: 200)
    }
    
    private func setupSignInBtn(){
        signInBtn.anchor(leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor,
                         height: 50.0)
    }
    
    private func layoutUI(){
        
        setupPlusPhoto()
        setupInputFields()
        setupSignInBtn()
    }

}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.plusPhotoImge.image = editedImage
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true)
    }
}
