//
//  SubtitleCell.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/13/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

class SubtitleCell: UITableViewCell {
    
    var subtitleName: UILabel = {
        let title = UILabel()
        title.contentMode = .left
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 18)
        title.textColor = UIColor.black
        title.numberOfLines = 0
        return title
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = UITableViewCell.SelectionStyle.gray
        // Initialization code
        addSubview(subtitleName)
        NSLayoutConstraint.activate([
            subtitleName.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            subtitleName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            subtitleName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            subtitleName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
