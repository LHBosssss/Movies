//
//  ActorCell.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/8/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit

class ActorCell: UICollectionViewCell {
    
    var actor: String? {
        didSet {
            guard let actorString = actor else { return }
            actorLabel.text = "  " + actorString + "  "
        }
    }
    
    let actorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .justified
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor().buttonColor().cgColor
        label.layer.borderWidth = 1
        label.backgroundColor = UIColor().bgColor()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor().textColor()
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        addSubview(actorLabel)

        actorLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        actorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        actorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        actorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
