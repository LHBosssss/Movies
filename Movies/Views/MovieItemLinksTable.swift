//
//  MovieItemLinksTable.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/9/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit

class MovieItemLinksView: UIView {

    var titles : [String]? {
        didSet {
            linksTable.reloadData()
        }
    }
    
    private let linksTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor().bgColor()
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        linksTable.dataSource = self
        linksTable.delegate = self
        linksTable.register(LinkCell.self, forCellReuseIdentifier: "LinkCell")
        NSLayoutConstraint.activate([
            linksTable.topAnchor.constraint(equalTo: self.topAnchor),
            linksTable.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            linksTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            linksTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieItemLinksView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
        cell.linkTitle.text = titles?[indexPath.row]
        return cell
    }
    
    
}

extension MovieItemLinksView: UITableViewDelegate {
    
}
