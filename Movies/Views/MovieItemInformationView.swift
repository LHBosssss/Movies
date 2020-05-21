//
//  MovieItemInformation.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/8/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import FontAwesome_swift
import iCarousel

class MovieItemInformationView: UIScrollView {
    
    var movieItem: MovieInformationModel? {
        didSet {
            guard let item = movieItem else { return }
            
            // Set Title
            let titleShadow = NSShadow()
            titleShadow.shadowColor = UIColor.gray
            titleShadow.shadowBlurRadius = 1.0
            titleShadow.shadowOffset = .zero
            let attrTitle = NSMutableAttributedString(string: item.viTitle.capitalized, attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 35),
                NSAttributedString.Key.shadow : titleShadow,
                NSAttributedString.Key.foregroundColor : UIColor().titleColor()
            ])
            let attrEnTitle = NSMutableAttributedString(string: "\n\(item.enTitle)", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25),
                NSAttributedString.Key.foregroundColor : UIColor().titleColor()
            ])
            attrTitle.append(attrEnTitle)
            movieTitle.attributedText = attrTitle
            
            // Set IMDB rating
            let rating = UILabel()
            rating.textColor = UIColor().textColor()
            rating.textAlignment = .right
            rating.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            rating.text = item.imdb
            
            var ratingInt = 0
            var ratingFloat: Float = 0.0
            if let rating = Float(item.imdb) {
                ratingInt = Int(rating)
                ratingFloat = rating
            }
            for num in 1...10 {
                let star = UIButton()
                star.isEnabled = false
                star.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: ratingInt >= num ? .solid : .regular)
                star.setTitleColor( UIColor().textColor(), for: .normal)
                star.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
                
                if ratingFloat > (Float(num - 1) + 0.5) && ratingFloat < Float(num) {
                    star.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
                    star.setTitle(String.fontAwesomeIcon(name: .starHalfAlt), for: .normal)
                }
                movieIMDB.addArrangedSubview(star)
            }
            movieIMDB.addArrangedSubview(rating)
            
            // Set Actors UICollectionView
            actors = item.actors
            actorsCollection.reloadData()
            
            // Set Extra Info
            let country = UIButton().extraLabel(text: item.country, name: .globe)
            let year = UIButton().extraLabel(text: item.year, name: .calendar)
            let time = UIButton().extraLabel(text: item.total, name: .clock)
            extraInfo.addArrangedSubview(country)
            extraInfo.addArrangedSubview(year)
            extraInfo.addArrangedSubview(time)
            
            // Set Movie About
            movieAbout.text = item.description
            
            // Set Movie Thumbnails
            thumbnails = item.images
            thumbnailsCollection.reloadData()
        }
    }
    // Set Title
    let movieTitle: UILabel = {
        let tit = UILabel()
        tit.textAlignment = .center
        tit.numberOfLines = 0
//        tit.adjustsFontSizeToFitWidth = true
        tit.translatesAutoresizingMaskIntoConstraints = false
        tit.textColor = UIColor.white
        tit.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return tit
    }()
    
    var movieIMDB: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.contentMode = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()
    
    var extraInfo: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.distribution = .fill
        return stack
    }()
    
    var actors = [String]()
    private let actorsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width: 100, height: 20)
        let actors = UICollectionView(frame: .zero, collectionViewLayout: layout)
        actors.translatesAutoresizingMaskIntoConstraints = false
        actors.showsHorizontalScrollIndicator = false
        actors.backgroundColor = UIColor().bgColor()
        return actors
    }()
    
    var movieAbout: UITextView = {
        let des = UITextView(frame: .zero)
        des.sizeToFit()
        des.isScrollEnabled = false
        des.isEditable = false
        des.backgroundColor = UIColor().bgColor()
        des.textColor = UIColor().textColor()
        des.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        des.textAlignment = .justified
        des.translatesAutoresizingMaskIntoConstraints = false
        return des
    }()
    
    var thumbnails = [String]()
    private let thumbnailsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.estimatedItemSize = CGSize(width: 150, height: 200)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = UIColor().bgColor()
        return collection
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayoutView()
    }
    
    func setupLayoutView() {
        // Add Movie Title
        addSubview(movieTitle)
        movieTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        movieTitle.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        movieTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        // Add Movie IMDB Rating
        addSubview(movieIMDB)
        movieIMDB.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 10).isActive = true
        movieIMDB.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        movieIMDB.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        movieIMDB.trailingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: 20).isActive = true
        
        // Add Movie Extra Info
        addSubview(extraInfo)
        extraInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        extraInfo.topAnchor.constraint(equalTo: movieIMDB.bottomAnchor).isActive = true
        extraInfo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add Movie Actors
        addSubview(actorsCollection)
        actorsCollection.dataSource = self
        actorsCollection.delegate = self
        actorsCollection.register(ActorCell.self, forCellWithReuseIdentifier: "ActorCell")
        actorsCollection.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actorsCollection.topAnchor.constraint(equalTo: extraInfo.bottomAnchor).isActive = true
        actorsCollection.heightAnchor.constraint(equalToConstant: 35).isActive = true
        actorsCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        actorsCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // Add Movie About
        addSubview(movieAbout)
        movieAbout.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        movieAbout.topAnchor.constraint(equalTo: actorsCollection.bottomAnchor, constant: 10).isActive = true
        movieAbout.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        movieAbout.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        // Add Movie Thumbnails
        addSubview(thumbnailsCollection)
        thumbnailsCollection.dataSource = self
        thumbnailsCollection.delegate = self
        thumbnailsCollection.register(ThumbnailCell.self, forCellWithReuseIdentifier: "ThumbnailCell")
        thumbnailsCollection.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        thumbnailsCollection.topAnchor.constraint(equalTo: movieAbout.bottomAnchor, constant: 10).isActive = true
        thumbnailsCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        thumbnailsCollection.heightAnchor.constraint(equalToConstant: 250).isActive = true
        thumbnailsCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        thumbnailsCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieItemInformationView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == actorsCollection {
            return actors.count
        } else {
            return thumbnails.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == actorsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCell", for: indexPath) as! ActorCell
            cell.actor = actors[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCell
            cell.imageURL = thumbnails[indexPath.item]
            return cell
        }
        
    }
}

extension MovieItemInformationView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == thumbnailsCollection {
            var newImageSize = CGSize(width: 300, height: 200)
            let imageURL = thumbnails[indexPath.item]
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
            if let imageSize = imageView.image?.size {
                let ratio = imageSize.width / imageSize.height
                let newWidth = 200 * ratio
                newImageSize = CGSize(width: newWidth, height: 200)
            }
            return newImageSize
        }
        else {
            guard let defaultSize = collectionView.cellForItem(at: indexPath)?.frame.size else {return CGSize(width: 100, height: 30)}
            return defaultSize
        }
    }
}


extension UIButton {
    func extraLabel(text: String, name: FontAwesome) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setImage(UIImage.fontAwesomeIcon(name: name, style: .solid, textColor: UIColor().bgColor(), size: CGSize(width: 20, height: 20)), for: .normal)
        button.setTitleColor(UIColor().bgColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        button.setTitle(text, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor().textColor()
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }
}
