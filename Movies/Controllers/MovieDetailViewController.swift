//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/7/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class MovieDetailViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let backgroundImage = UIImage(named: "background")
        let view = UIImageView()
        view.image = backgroundImage
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let informationView: MovieItemInformationView = {
        let view = MovieItemInformationView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.backgroundColor = UIColor().bgColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    private let linksView: MovieItemLinksView = {
        let view = MovieItemLinksView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.backgroundColor = UIColor().bgColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    private var loadingIndicator = NVActivityIndicatorView(frame: .zero)
    
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
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.isHidden = true
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 50, style: .regular)
        button.setTitle(String.fontAwesomeIcon(name: .playCircle), for: .normal)
        button.setTitleColor(UIColor().titleColor(), for: .normal)
        button.setTitleColor(UIColor().buttonColor(), for: .highlighted)
        button.titleLabel?.clipsToBounds = true
        button.titleLabel?.layer.masksToBounds = true
        button.titleLabel?.layer.cornerRadius = 25
        button.titleLabel?.layer.shadowColor = UIColor.gray.cgColor
        button.titleLabel?.layer.shadowOpacity = 1
        button.titleLabel?.layer.shadowOffset = .zero
        button.titleLabel?.layer.shadowRadius = 5
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.backgroundColor = UIColor().bgColor()
        button.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        return button
    }()
    
    var movieItem = MovieModel()
    private var movieItemManager = MovieItemManager()
    private var isShowListLink = false
    private var listLink = [String]()
    // MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        movieItemManager.delegate = self
        view.backgroundColor = UIColor().bgColor()
        setupMovieImage()
        setupInformationView()
        setupLinksView()
        setupCloseButton()
        setupPlayButton()
        movieItemManager.getMovieInformation(link: movieItem.link)
        showLoadingIndicator()
    }
    @objc func handleCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePlayButton() {
        isShowListLink = !isShowListLink
        informationView.isHidden = isShowListLink
        linksView.isHidden = !isShowListLink
        if isShowListLink {
            showLoadingIndicator()
            movieItemManager.getMovieLink(id: movieItem.id)
        }
    }
    
    func setupMovieImage() {
        view.addSubview(backgroundImageView)
        DispatchQueue.main.async {
            self.backgroundImageView.sd_setImage(with: URL(string: self.movieItem.image), completed: nil)
        }
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setupInformationView() {
        view.addSubview(informationView)
        NSLayoutConstraint.activate([
            informationView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            informationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            informationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            informationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        informationView.contentSize = CGSize(width: informationView.frame.width, height: informationView.frame.height)
    }
    
    func setupCloseButton() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
        ])
    }
    
    func setupPlayButton() {
        view.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: informationView.topAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func setupLinksView() {
        view.addSubview(linksView)
        linksView.delegate = self
        NSLayoutConstraint.activate([
            linksView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            linksView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            linksView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            linksView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        linksView.isHidden = true
    }
    
    // MARK: - Indicator Function
    func showLoadingIndicator() {
        let frame = CGRect(x: view.center.x - 25, y: view.center.y - 25, width: 50, height: 50)
        loadingIndicator = NVActivityIndicatorView(frame: frame, type: .ballTrianglePath, color: UIColor().titleColor(), padding: 0)
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        playButton.isHidden = false
        closeButton.isHidden = false
        loadingIndicator.stopAnimating()
    }
}

extension MovieDetailViewController: MovieItemManagerDelegate {
    func getMovieLinkSuccess(links: Dictionary<String, String>) {
        let titleArray: [String] = Array(links.keys)
        linksView.titles = titleArray
        linksView.listLink = links
        hideLoadingIndicator()
    }

    
    func getMovieLinkFailed() {
        hideLoadingIndicator()
    }
    
    func getMovieInformationSuccess(movieItem: MovieInformationModel) {
        hideLoadingIndicator()
        let item = movieItem
        item.viTitle = self.movieItem.title
        self.movieItem.id != item.id ? self.movieItem.id = item.id : nil
        informationView.movieItem = item
        informationView.movieItem?.printMovieItem()
        
    }
    
    func getMovieInformationFailed() {
        hideLoadingIndicator()
        informationView.movieItem = MovieInformationModel()
    }
}

extension MovieDetailViewController: MovieItemLinksViewDelegate {
    func getDirectLinkSuccess(link: String, title: String) {
        print("Get link Success, going to player")
        let vc = MoviePlayerViewController()
        vc.mediaURL = link
        vc.movieTitle = title
        vc.movieEnTitle = informationView.movieItem?.enTitle
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func getDirectLinkFailed() {
        print("Get link Failed, Choose another link")
        let alert = UIAlertController().getLinkError()
        present(alert, animated: true, completion: nil)
    }
}


extension UIColor {
    
    func bgColor() -> UIColor {
        let bgColor = UIColor(red: 0.85, green: 0.88, blue: 0.91, alpha: 1.00)
        return bgColor
    }
    func buttonColor() -> UIColor {
        let buttonColor = UIColor(red: 0.00, green: 0.56, blue: 0.62, alpha: 1.00)
        return buttonColor
    }
    func textColor() -> UIColor {
        let textColor = UIColor(red: 0.15, green: 0.29, blue: 0.43, alpha: 1.00)
        return textColor
    }
    func titleColor() -> UIColor {
        let titleColor = UIColor(red: 0.08, green: 0.16, blue: 0.31, alpha: 1.00)
        return titleColor
    }
}

extension UIAlertController {
    func getLinkError() -> UIAlertController {
        let alert = UIAlertController(title: "Link bị lỗi! Vui lòng chọn link khác.", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        return alert
    }
}
