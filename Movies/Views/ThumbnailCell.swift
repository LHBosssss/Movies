//
//  MoviePageCell.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/4/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import SDWebImage

class ThumbnailCell: UICollectionViewCell {
    
    var imageURL: String? {
        didSet {
            guard let link = imageURL else {return}
            thumbnailImageView.sd_setImage(with: URL(string: link), completed: nil)
            thumbnailImageView.frame = self.frame
            thumbnailImageView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
            thumbnailImageView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        }
    }
    
    lazy var thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor().bgColor().cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        backgroundColor = UIColor().bgColor()
        layer.cornerRadius = 10
        layer.borderColor = UIColor().bgColor().cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        
        addSubview(thumbnailImageView)
        thumbnailImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
