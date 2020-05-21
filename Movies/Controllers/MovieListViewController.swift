//
//  MovieListView.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/4/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import iCarousel
import NVActivityIndicatorView

class MovieListViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor().bgColor()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let menuButton: UIButton = {
        let menu = UIButton().controlButton(name: .caretSquareLeft)
        menu.setTitleColor(UIColor().bgColor(), for: .normal)
        menu.setTitleColor(UIColor().titleColor(), for: .highlighted)
        menu.addTarget(self, action: #selector(handleMenu), for: .touchUpInside)
        return menu
    }()
    
    private let menuView: MenuView = {
        let menu = MenuView()
        menu.autoresizesSubviews = true
        menu.autoresizingMask = [.flexibleHeight,.flexibleWidth,.flexibleTopMargin,.flexibleBottomMargin,.flexibleLeftMargin,.flexibleRightMargin]
        menu.translatesAutoresizingMaskIntoConstraints = false
        return menu
    }()
    
    private let carousel: iCarousel = {
        let carousel = iCarousel()
        carousel.backgroundColor = .none
        carousel.translatesAutoresizingMaskIntoConstraints = false
        carousel.isPagingEnabled = true
        carousel.isScrollEnabled = true
        carousel.type = .rotary
        carousel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        carousel.autoresizesSubviews = true
        return carousel
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.isHidden = true
        pc.currentPage = 0
        pc.numberOfPages = 5
        pc.pageIndicatorTintColor = UIColor().textColor()
        pc.currentPageIndicatorTintColor = .white
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.addTarget(self, action: #selector(handlePageControlChanged), for: .valueChanged)
        return pc
    }()
    
    private let watchButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setTitle("WATCH THIS MOVIE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor().titleColor(), for: .normal)
        button.setTitleColor(UIColor().textColor(), for: .highlighted)
        button.backgroundColor = UIColor().bgColor()
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.addTarget(self, action: #selector(handleWatchThisMovie), for: .touchUpInside)
        return button
    }()
    
    private var loadingIndicator = NVActivityIndicatorView(frame: .zero)
    
    private var menuIsOpened = false
    var bottomControlsStackView = UIStackView()
    var movieManager = ListMovieManager()
    var searchManager = SearchMovieManager()
    var listMovies = [MovieModel]()
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        movieManager.delegate = self
        searchManager.delegate = self
        carousel.dataSource = self
        carousel.delegate = self
        
        // Setup View Layout
        setupMenuView()
        setupBottomControls()
        setupWatchThisMovie()
        setupCollection()
        
        // Get Hot Movie
        movieManager.getHotMovie()
        showLoadingIndicator()
    }
    
    // MARK:- Setup Menu View
    
    func setupMenuView() {
        menuView.delegate = self
        view.addSubview(menuButton)
        view.addSubview(menuView)
        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            menuView.topAnchor.constraint(equalTo: menuButton.bottomAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -view.frame.width/2),
            menuView.trailingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        
        
    }
    // MARK:- Setup Movie Collection View
    
    func setupCollection() {
        view.addSubview(backgroundImageView)
        view.addSubview(carousel)
        view.sendSubviewToBack(carousel)
        view.sendSubviewToBack(backgroundImageView)

        let frame = CGRect(x: view.center.x - 25, y: view.center.y - 25, width: 50, height: 50)
        loadingIndicator = NVActivityIndicatorView(frame: frame, type: .ballTrianglePath, color: UIColor().titleColor(), padding: 0)
        loadingIndicator.isHidden = false
        view.addSubview(loadingIndicator)
        view.bringSubviewToFront(loadingIndicator)
        
        // tap recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            carousel.bottomAnchor.constraint(equalTo: watchButton.topAnchor, constant: -20),
            carousel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carousel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carousel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
        ])
    }
    
    @objc func handleTap() {
        print("Tapped")
        if menuIsOpened {
            menuView.handleTap()
            handleMenu()
        }
    }
    
    // MARK: - Setup Page Control
    
    fileprivate func setupBottomControls() {
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func handleMenu() {
        print("Menu Button Pressed")
        let translation = menuView.frame.size.width
        UIView.animate(withDuration: 0.3, animations: {
            print(self.menuIsOpened)
            if !self.menuIsOpened {
                print(-CGFloat.pi)
                self.menuButton.transform = self.menuButton.transform.rotated(by: -CGFloat.pi)
                self.view.bringSubviewToFront(self.menuView)
                self.menuView.transform = CGAffineTransform(translationX: translation, y: 0)
            } else {
                print(CGFloat.pi)
                self.menuButton.transform = self.menuButton.transform.rotated(by: CGFloat.pi)
                self.menuView.transform = .identity
            }
            self.menuIsOpened = !self.menuIsOpened

        }) { (_) in
        }
    }
    
    @objc private func handlePageControlChanged() {
        if carousel.currentItemIndex != pageControl.currentPage {
            carousel.scrollToItem(at: pageControl.currentPage, animated: true)
        }
    }
    
    
    // MARK:- Setup Watch Button UI and Function
    
    
    fileprivate func setupWatchThisMovie() {
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(watchButton)
        NSLayoutConstraint.activate([
            watchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: 0),
            watchButton.widthAnchor.constraint(equalToConstant: view.frame.width * 3/4),
            watchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func handleWatchThisMovie() {
        presentToMovieDetail(index: self.carousel.currentItemIndex)
    }
    
    // MARK: - Indicator Function
    func showLoadingIndicator() {
        print("Showing Login Indicator")
        // Add Indicator
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        watchButton.isHidden = false
        pageControl.isHidden = false
        view.isUserInteractionEnabled = true
    }
    
}

// MARK: - Movie List View DataSource

extension MovieListViewController: iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return listMovies.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let cell = MoviePageCell(frame: CGRect(x: 0, y: 0, width: carousel.frame.width * 3 / 4, height: carousel.frame.height))
        cell.movieItem = listMovies[index]
        return cell
    }
}

// MARK: - Movie List View Delegate

extension MovieListViewController: iCarouselDelegate {
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        var result: CGFloat
        switch option {
        case iCarouselOption.spacing:
            result = 1.25
            return result
        case iCarouselOption.radius:
            result = value*0.9
            return result
        case iCarouselOption.showBackfaces:
            result = 0.0
            return result
        case iCarouselOption.wrap:
            result = 0.0
            return result
        default:
            result = value
            break
        }
        return result
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (_) in
            self.carousel.reloadData()
        }) { (_) in
        }
        
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        let currentIndex = carousel.currentItemIndex
        print(currentIndex)
        if pageControl.currentPage < currentIndex {
            changeBackground(direction: "left")
        } else {
            changeBackground(direction: "right")
            
        }
        pageControl.currentPage = currentIndex
    }
    
    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return carousel.frame.width * 3 / 4
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        print("Selected Item at index: \(index)")
        presentToMovieDetail(index: index)
    }
    
    func presentToMovieDetail(index: Int) {
        let vc = MovieDetailViewController()
        vc.movieItem = listMovies[index]
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
    }
    
    func changeBackground(direction: String) {
        let unwrappedImageString = listMovies[carousel.currentItemIndex].image
        let imageView = UIImageView()
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        view.sendSubviewToBack(backgroundImageView)
        var xPosition = view.frame.width
        if direction == "right" {
            xPosition = -xPosition
        }
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.frame = CGRect(x: xPosition, y: 0, width: view.frame.width, height: self.backgroundImageView.frame.height)
        imageView.sd_setImage(with: URL(string: unwrappedImageString), completed: nil)
        
        UIView.animate(withDuration: 0.3, animations: {
            var translationX = self.backgroundImageView.frame.width
            if direction == "left" {
                translationX = -translationX
            }
            imageView.transform = CGAffineTransform(translationX: translationX, y: 0)
        }) { (completed) in
            self.backgroundImageView.image = imageView.image
            imageView.removeFromSuperview()
        }
    }
}

extension MovieListViewController: ListMovieManagerDelegate {
    func getMoviesSuccess(listMovies: [MovieModel]) {
        print("Get Movies Success")
        hideLoadingIndicator()
        self.listMovies = listMovies
        DispatchQueue.main.async {
            self.backgroundImageView.sd_setImage(with: URL(string: listMovies[0].image), completed: nil)
        }
        pageControl.numberOfPages = self.listMovies.count
        carousel.reloadData()
        carousel.scrollToItem(at: 0, animated: true)
    }
    
    func getMoviesFailed() {
        print("Get hot movies Failed")
        hideLoadingIndicator()
    }
}

extension MovieListViewController: MenuViewDelegate {
    func didSelectMenuItem(genre: String) {
        print("Selected \(genre)")
        movieManager.getGenreMovie(genre: genre)
        if genre != "phim-le" && genre != "series" {
            handleMenu()
        }
        showLoadingIndicator()
    }
    
    func didPressSearchButton(text: String) {
        print("Search Text: \(text)")
        showLoadingIndicator()
        searchManager.searchMovie(title: text)
        handleMenu()
    }
}

extension MovieListViewController: SearchMovieManagerDelegate {
    func searchMovieSuccess(listMovies: [MovieModel]) {
        hideLoadingIndicator()
        print("Search Success")
        print(listMovies)
        self.listMovies = listMovies
        pageControl.numberOfPages = self.listMovies.count
        carousel.reloadData()
        carousel.scrollToItem(at: 0, animated: true)

    }
    
    func searchMovieFailed() {
        print("Search Failed")
        hideLoadingIndicator()
    }
    
    
}
