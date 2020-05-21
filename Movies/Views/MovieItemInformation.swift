//
//  MovieItemInformation.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/8/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit

class MovieItemInformationView: UIScrollView {
    
    var movieItem: MovieInformationModel? {
        didSet {
            guard let item = movieItem else { return }
            
            // Set Title
            let titleShadow = NSShadow()
            titleShadow.shadowColor = UIColor().titleColor().cgColor
            titleShadow.shadowBlurRadius = 1.0
            titleShadow.shadowOffset = .zero
            
            let attrTitle = NSMutableAttributedString(string: item.viTitle.capitalized, attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25),
                NSAttributedString.Key.shadow : titleShadow,
                NSAttributedString.Key.foregroundColor : UIColor().bgColor()
            ])
            
            let attrEnTitle = NSMutableAttributedString(string: "\n\(item.enTitle.capitalized)", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor : UIColor().titleColor()
            ])
            
            attrTitle.append(attrEnTitle)
            
            movieTitle.attributedText = attrTitle
        }
        
    }
    // Set Title
    let movieTitle: UILabel = {
        let tit = UILabel()

        tit.textAlignment = .left
        tit.numberOfLines = 0
        tit.adjustsFontSizeToFitWidth = true
        tit.translatesAutoresizingMaskIntoConstraints = false
        tit.textColor = UIColor.white
        tit.text = "Test Test Test Test Test Test Test Test".capitalized
        tit.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return tit
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSuperView()
        setupLayoutView()
    }
    
    
    func setupSuperView() {
        backgroundColor = UIColor().bgColor()
        layer.cornerRadius = 10
        layer.borderColor = UIColor().bgColor().cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLayoutView() {
        // Setup Title Vi + En
        addSubview(movieTitle)
        
        // Setup Layout
        NSLayoutConstraint.activate([
            movieTitle.topAnchor.constraint(equalTo: topAnchor),
            movieTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            movieTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
