//
//  MoviePageCell.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/4/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import SDWebImage
class MoviePageCell: UIView {
    
    var movieItem: MovieModel? {
        didSet {
            guard let unwrappedMovieItem = movieItem else {
                return
            }
            // Set image
            DispatchQueue.main.async {
                self.movieImageView.sd_setImage(with: URL(string: unwrappedMovieItem.image), completed: nil)
            }
            // Set Title and Year
            let titleShadow = NSShadow()
            titleShadow.shadowColor = UIColor.gray
            titleShadow.shadowBlurRadius = 0.5
            titleShadow.shadowOffset = CGSize(width: 1, height: 1)
            let attributedTitle = NSMutableAttributedString(string: unwrappedMovieItem.title.capitalized, attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25),
                NSAttributedString.Key.shadow : titleShadow,
                NSAttributedString.Key.foregroundColor : UIColor().titleColor()
            ])
            
            let attributedYear = NSMutableAttributedString(string: "\n\(unwrappedMovieItem.year)", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .light),
                NSAttributedString.Key.foregroundColor : UIColor().textColor()
            ])
            attributedTitle.append(attributedYear)
            
            movieTitle.attributedText = attributedTitle
        }
    }

    
    private let movieImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor().bgColor().cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .none
        view.contentMode = .scaleAspectFill
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieTitle: UILabel = {
        let title = UILabel()
        title.text = "Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test "
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 30)
        title.textAlignment = .center
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true
        title.backgroundColor = UIColor().bgColor()
        title.layer.cornerRadius = 3
        title.layer.masksToBounds = true
        title.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return title
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        autoresizesSubviews = true
        backgroundColor = UIColor().bgColor()
        layer.cornerRadius = 10
        layer.borderColor = UIColor().bgColor().cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        
        addSubview(movieImageView)
        movieImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        movieImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        movieImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        
        //
        addSubview(movieTitle)
        movieTitle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        movieTitle.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -40).isActive = true
        movieTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
