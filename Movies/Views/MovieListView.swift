//
//  MovieListView.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/4/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import iCarousel

class MovieListViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let backgroundImage = UIImage(named: "background")
        let view = UIImageView()
        view.image = backgroundImage
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let carousel: iCarousel = {
        let carousel = iCarousel()
        carousel.backgroundColor = .none
        carousel.translatesAutoresizingMaskIntoConstraints = false
        carousel.isPagingEnabled = true
        carousel.isScrollEnabled = true
        carousel.type = .rotary
        return carousel
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 20
        pc.pageIndicatorTintColor = .gray
        pc.currentPageIndicatorTintColor = .white
        return pc
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Previous", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.green, for: .selected)
        button.setTitleColor(.green, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    private let watchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("WATCH THIS MOVIE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleWatchThisMovie), for: .touchUpInside)
        return button
    }()
    
    var bottomControlsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.dataSource = self
        carousel.delegate = self
        setupBottomControls()
        setupWatchThisMovie()
        setupCollection()
    }
    
    // MARK:- Setup Movie Collection View
    
    func setupCollection() {
        view.addSubview(backgroundImageView)
        view.addSubview(carousel)
        view.sendSubviewToBack(carousel)
        view.sendSubviewToBack(backgroundImageView)
        
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
    
    
    // MARK: - Setup Page Control UI And Function
    
    fileprivate func setupBottomControls() {
        bottomControlsStackView = UIStackView(arrangedSubviews: [pageControl])
        //            [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc private func handlePrevious() {
        let preIndex = max(pageControl.currentPage - 1, 0)
        pageControl.currentPage = preIndex
        carousel.scrollToItem(at: preIndex, animated: true)
    }
    
    @objc private func handleNext() {
        print("Trying to advance to next")
        let nextIndex = min(pageControl.currentPage + 1, pageControl.numberOfPages - 1)
        pageControl.currentPage = nextIndex
        carousel.scrollToItem(at: nextIndex, animated: true)
    }
    
    // MARK:- Setup Watch Button UI and Function
    
    
    fileprivate func setupWatchThisMovie() {
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(watchButton)
        NSLayoutConstraint.activate([
            watchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchButton.bottomAnchor.constraint(equalTo: bottomControlsStackView.topAnchor, constant: 0),
            watchButton.widthAnchor.constraint(equalToConstant: view.frame.width * 3/4),
            watchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc private func handleWatchThisMovie() {
        print("handleWatchThisMovie")
        watchMovieAnimation()
    }
    
    fileprivate func watchMovieAnimation() {
        
    }
    
}

// MARK: - Movie List View DataSource

extension MovieListViewController: iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 20
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let cell = MoviePageCell(frame: CGRect(x: 0, y: 0, width: carousel.frame.width * 3 / 4, height: carousel.frame.height))
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
            result = value*0.88
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
    
    func carouselDidEndDecelerating(_ carousel: iCarousel) {
        print(carousel.currentItemIndex)
        pageControl.currentPage = carousel.currentItemIndex
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if index == carousel.currentItemIndex {
            if let currentCell = carousel.currentItemView {
                UIView.animate(withDuration: 0.1,
                               animations: {
                                //Fade-out
                                currentCell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                })
                { (completed) in
                    UIView.animate(withDuration: 0.1,
                                   animations: {
                                    //Fade-out
                                    currentCell.transform = CGAffineTransform.identity
                                    currentCell.transform = CGAffineTransform.init(translationX: 0, y: -50)
                    })
                }
            }
        }
    }
}
