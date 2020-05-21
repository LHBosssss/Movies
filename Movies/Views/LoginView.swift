//
//  ViewController.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/4/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Variables
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "fsharelogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loginUsername: UITextField = {
        let user = UITextField()
        user.text = "hoduyluong2108@gmail.com"
        user.textAlignment = .center
        user.placeholder = "Enter your email."
        user.translatesAutoresizingMaskIntoConstraints = false
        user.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return user
    }()
    
    private let loginPassword: UITextField = {
        let pass = UITextField()
        pass.text = "FUCKyou2108"
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
        lgbutton.addTarget(self, action: #selector(handlerLogin), for: .touchUpInside)
        return lgbutton
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .whiteLarge)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        loading.stopAnimating()
        return loading
    }()
    
    private let loadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view.isHidden = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.alpha = 0.7
        view.clipsToBounds = true
        return view
    }()
    
    
    // MARK: - Control Variables
    
    private var fshareManager = FshareManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fshareManager.delegate = self
        setupLoginView()
        showLoginIndicator()
        fshareManager.loadSession()
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupLoginView() {
        
        let loginStack = UIStackView(arrangedSubviews: [logoImage, loginUsername, loginPassword, loginButton])
        loginStack.translatesAutoresizingMaskIntoConstraints = false
        loginStack.distribution = .fill
        loginStack.spacing = 20
        loginStack.axis = .vertical
        loginStack.alignment = .center
        view.addSubview(loginStack)
        view.sendSubviewToBack(loginStack)
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
            loginButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    @objc private func handlerLogin() {
        if let username = loginUsername.text, let password = loginPassword.text {
            if username != "" && password != "" {
                showLoginIndicator()
                fshareManager.login(email: username, pass: password)
            }
        }
    }
    
    func showLoginIndicator() {
        print("Showing Login Indicator")
        // Add Indicator
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        view.isUserInteractionEnabled = false
        loadingView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
    }
    
    func hideLoginIndicator() {
        loadingIndicator.stopAnimating()
        loadingView.isHidden = true
        view.isUserInteractionEnabled = true
    }
}

// MARK: - Fshare Manager Delegate

extension LoginViewController: FshareManagerDelegate {
    func noSessionFound() {
        print("No session is Founded")
        hideLoginIndicator()
    }
    
    func sessionIsAlive() {
        hideLoginIndicator()
        print("Session Is Alive")
        let vc = MovieListView()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func sessionIsDead() {
        hideLoginIndicator()
        print("Session Is Dead")
        let alert = UIAlertController(title: "Lỗi đăng nhập", message: "Phiên đăng nhập đã hết hạn. Mời bạn đăng nhập lại.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func loginSuccess() {
        hideLoginIndicator()
        print("Login Success")
        let vc = MovieListView()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func loginFailed() {
        hideLoginIndicator()
        print("Login Failed")
        let alert = UIAlertController(title: "Đăng nhập không thành công!", message: "Vui lòng kiểm tra lại email và mật khẩu.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

