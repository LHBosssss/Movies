//
//  SubtitleDownloadViewController.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/13/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit

class SubtitleSearchViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Enter Movie Title."
        search.autocapitalizationType = UITextAutocapitalizationType.words
        search.barStyle = .blackTranslucent
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    var titleToSearch: String? {
        didSet {
            guard let title = titleToSearch else { return }
            searchBar.text = title
            print(searchBar.text)
        }
    }
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.isHidden = true
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 40, style: .solid)
        button.setTitle(String.fontAwesomeIcon(name: .caretDown), for: .normal)
        button.setTitleColor(UIColor().titleColor(), for: .normal)
        button.setTitleColor(UIColor().buttonColor(), for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.backgroundColor = .none
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    
    // MARK:- SUPER VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSuperView()
        setupCloseButton()
        setupSearchBar()
    }
    
    @objc private func handleCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupSuperView() {
        view.backgroundColor = UIColor().bgColor()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupCloseButton() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
        ])
    }
    
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: closeButton.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}
