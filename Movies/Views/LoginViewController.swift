//
//  ViewController.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/4/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

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
        lgbutton.layer.cornerRadius = 3
        lgbutton.addTarget(self, action: #selector(handlerLogin), for: .touchUpInside)
        return lgbutton
    }()
    
    private var loadingIndicator = NVActivityIndicatorView(frame: .zero)
    
    
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
        view.backgroundColor = UIColor().bgColor()
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
        // Add Indicator
        let frame = CGRect(x: view.center.x - 25, y: view.center.y - 25, width: 50, height: 50)
        loadingIndicator = NVActivityIndicatorView(frame: frame, type: .ballTrianglePath, color: UIColor().titleColor(), padding: 0)
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func hideLoginIndicator() {
                loadingIndicator.stopAnimating()
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
        let vc = MovieListViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func sessionIsDead() {
        hideLoginIndicator()
        let alert = UIAlertController(title: "Lỗi đăng nhập", message: "Phiên đăng nhập đã hết hạn. Mời bạn đăng nhập lại.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okButton)
//        present(alert, animated: true, completion: nil)
        
        if loginUsername.text != "" && loginPassword.text != "" {
            self.handlerLogin()
        }
    }
    
    func loginSuccess() {
        hideLoginIndicator()
        let vc = MovieListViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func loginFailed() {
        hideLoginIndicator()
        let alert = UIAlertController(title: "Đăng nhập không thành công!", message: "Vui lòng kiểm tra lại email và mật khẩu.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

