//
//  SubtitleDownloadViewController.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/13/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SubtitleSearchViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Enter Movie Title"
        search.autocapitalizationType = UITextAutocapitalizationType.words
        search.barStyle = .default
        search.searchBarStyle = .prominent
        search.translatesAutoresizingMaskIntoConstraints = false
        search.showsCancelButton = true
        search.setShowsCancelButton(true, animated: true)
        return search
    }()
    
    var titleToSearch: String? {
        didSet {
            guard let title = titleToSearch else { return }
            let pattern = "[^A-Za-z]+"
            let result = title.replacingOccurrences(of: pattern, with: " ", options: [.regularExpression])
            let searchTitle = result.replacingOccurrences(of: " ", with: "-")
            searchBar.text = searchTitle
            subtitleManager?.getListMovie(title: searchTitle)
            showLoadingIndicator()
        }
    }
    
    private let listSearchResult: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private var loadingIndicator = NVActivityIndicatorView(frame: .zero)
    var subtitleManager: SubtitleManager?
    private var listMovieSubtitle = [Dictionary<String, String>]()
    // MARK:- SUPER VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        subtitleManager?.delegate = self
        setupSuperView()
        setupSearchBar()
        setupListSearchResult()
    }
    
    func setupSuperView() {
        view.backgroundColor = UIColor().bgColor()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subtitleManager?.selectedDelegate2 = self
    }
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func setupListSearchResult() {
        listSearchResult.tableFooterView = UIView()
        listSearchResult.delegate = self
        listSearchResult.dataSource = self
        listSearchResult.register(SubtitleCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(listSearchResult)
        NSLayoutConstraint.activate([
            listSearchResult.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            listSearchResult.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listSearchResult.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listSearchResult.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showLoadingIndicator() {
        let frame = CGRect(x: view.center.x - 25, y: view.center.y - 25, width: 50, height: 50)
        loadingIndicator = NVActivityIndicatorView(frame: frame, type: .ballTrianglePath, color: UIColor().titleColor(), padding: 0)
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
}

extension SubtitleSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMovieSubtitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubtitleCell
        cell.subtitleName.text = listMovieSubtitle[indexPath.row]["title"]
        return cell
    }
    
    
}

extension SubtitleSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(listMovieSubtitle[indexPath.row]["link"])
        let vc = SubtitleSelectViewController()
        vc.subtitleManager = subtitleManager
        vc.linkToGet = listMovieSubtitle[indexPath.row]["link"]
        vc.titleToDisplay = listMovieSubtitle[indexPath.row]["title"]
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
    }
    
}

extension SubtitleSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let title = searchBar.text else { return }
        let searchTitle = title.replacingOccurrences(of: " ", with: "-")
        subtitleManager?.getListMovie(title: searchTitle)
        showLoadingIndicator()
    }
}


extension SubtitleSearchViewController: SubtitleManagerDelegate {
    func getListMovieSuccess(list: [Dictionary<String, String>]) {
        hideLoadingIndicator()
        listMovieSubtitle = list
        listSearchResult.reloadData()
    }
    
    func getListFailed() {
        print("getListMovieFailed")
        hideLoadingIndicator()
    }
    
}

extension SubtitleSearchViewController: SelectedSubtitleDelegate {
    func didSelectSubtitle(filePath: String) {
        self.dismiss(animated: false, completion: nil)
    }
}
