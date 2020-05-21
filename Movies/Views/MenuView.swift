//
//  MenuView.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/14/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func didSelectMenuItem(genre: String)
    func didPressSearchButton(text: String)
}

class MenuView: UIView {
    
    private let menuTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor().bgColor()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        table.autoresizesSubviews = true
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.contentMode = .center
        return table
    }()
    
    private let backButton: UIButton = {
        let backButton = UIButton().controlButton(name: .caretLeft)
        backButton.isEnabled = true
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return backButton
    }()
    
    private let menuName: UILabel = {
        let name = UILabel()
        name.text = "Main Menu"
        name.textColor = UIColor().titleColor()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.numberOfLines = 1
        name.adjustsFontSizeToFitWidth = true
        name.textAlignment = .center
        return name
    }()
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Movie Name"
        search.barStyle = .default
        return search
    }()
    private var listMenu = [Dictionary<String, String>]()
    private var selectedSection: String?
    private var categoryManager = CategoryManager()
    var delegate: MenuViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSearchBar()
        setupTopBar()
        setupMenuTable()
        createFirstData()
    }
    
    
    
    @objc func handleBack() {
        print("Back Pressed")
        createFirstData()
    }
    
    
    func setupView() {
        self.backgroundColor = UIColor().bgColor()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        print("Tapped")
        searchBar.resignFirstResponder()
    }
    
    func setupSearchBar() {
        addSubview(searchBar)
        searchBar.delegate = self
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    
    func setupTopBar() {
        
        addSubview(backButton)
        addSubview(menuName)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            menuName.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            menuName.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            menuName.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuName.bottomAnchor.constraint(equalTo: backButton.bottomAnchor),
        ])
    }
    
    func setupMenuTable() {
        menuTable.dataSource = self
        menuTable.delegate = self
        menuTable.tableFooterView = UIView()
        addSubview(menuTable)
        
        NSLayoutConstraint.activate([
            menuTable.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            menuTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuTable.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        frame.size.height = menuTable.contentSize.height
    }
    
    func createFirstData() {
        listMenu = categoryManager.mainMenu
        menuTable.reloadData()
        menuName.text = "Main Menu"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")
        cell?.textLabel?.text = listMenu[indexPath.row]["title"]
        cell?.backgroundColor = UIColor().bgColor()
        cell?.textLabel?.textColor = UIColor().textColor()
        return cell!
    }
    
}

extension MenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let genre = listMenu[indexPath.row]["genre"] {
            self.delegate?.didSelectMenuItem(genre: genre)
            print(genre)
        }
        self.menuName.text = listMenu[indexPath.row]["title"]
        if let subMenu = listMenu[indexPath.row]["sub"] {
            print("Have Sub")
            switch subMenu {
            case "phim-le":
                listMenu = categoryManager.phimleMenu
            case "series":
                listMenu = categoryManager.phimboMenu
            default:
                listMenu = categoryManager.mainMenu
            }
            menuTable.reloadData()
        }
    }
}

extension MenuView: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let title = searchBar.text else { return }
        self.delegate?.didPressSearchButton(text: title)
        
    }
}
