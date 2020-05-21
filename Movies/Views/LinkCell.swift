//
//  LinkCell.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/9/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit

class LinkCell: UITableViewCell {
    
    var linkTitle: UILabel = {
        let title = UILabel()
        title.contentMode = .left
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20)
        title.backgroundColor = UIColor().bgColor()
        title.textColor = UIColor().textColor()
        title.numberOfLines = 0
        return title
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor().bgColor()
        selectionStyle = UITableViewCell.SelectionStyle.gray
        // Initialization code
        addSubview(linkTitle)
        NSLayoutConstraint.activate([
            linkTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            linkTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            linkTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            linkTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
