//
//  ViewController.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/4/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "fsharelogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loginUsername: UITextField = {
        let user = UITextField()
        user.textAlignment = .center
        user.placeholder = "Enter your email."
        user.translatesAutoresizingMaskIntoConstraints = false
        user.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return user
    }()
    
    private let loginPassword: UITextField = {
        let pass = UITextField()
        pass.textAlignment = .center
        pass.isSecureTextEntry = true
        pass.placeholder = "Enter your password."
        pass.translatesAutoresizingMaskIntoConstraints = false
        pass.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return pass
    }()
    
    private let loginButton: UIButton = {
        let lgbutton = UIButton(type: .system)
        lgbutton.setTitle("Login", for: .normal)
        lgbutton.setTitleColor(.white, for: .normal)
        lgbutton.setTitleColor(.blue, for: .highlighted)
        lgbutton.backgroundColor = .red
        lgbutton.translatesAutoresizingMaskIntoConstraints = false
        lgbutton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lgbutton.layer.cornerRadius = 10
        return lgbutton
    }()

    fileprivate func setupLoginView() {
                
        let loginStack = UIStackView(arrangedSubviews: [logoImage, loginUsername, loginPassword, loginButton])
        loginStack.translatesAutoresizingMaskIntoConstraints = false
        loginStack.distribution = .fill
        loginStack.spacing = 20
        loginStack.axis = .vertical
        loginStack.alignment = .center
        view.addSubview(loginStack)
        
        NSLayoutConstraint.activate([
            loginStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            logoImage.centerXAnchor.constraint(equalTo: loginStack.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 100),
            logoImage.widthAnchor.constraint(equalToConstant: 100),
            
            loginUsername.leadingAnchor.constraint(equalTo: loginStack.leadingAnchor),
            loginUsername.trailingAnchor.constraint(equalTo: loginStack.trailingAnchor),
            
            loginPassword.leadingAnchor.constraint(equalTo: loginStack.leadingAnchor),
            loginPassword.trailingAnchor.constraint(equalTo: loginStack.trailingAnchor),
            
            loginButton.centerXAnchor.constraint(equalTo: loginStack.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLoginView()
    }
    
}

