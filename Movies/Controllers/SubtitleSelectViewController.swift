//
//  SubtitleSelectViewController.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/13/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Zip

class SubtitleSelectViewController: UIViewController {
    
    var titleToDisplay: String? {
        didSet {
            guard let title = titleToDisplay else { return }
            titleLabel.text = title
        }
    }
    
    var linkToGet: String? {
        didSet {
            guard let link = linkToGet else { return }
            subtitleManager?.getListSubtitle(link: link)
            showLoadingIndicator()
        }
    }
    
    private let topBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor().bgColor()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.isHidden = false
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 40, style: .solid)
        button.setTitle(String.fontAwesomeIcon(name: .caretDown), for: .normal)
        button.setTitleColor(UIColor().titleColor(), for: .normal)
        button.setTitleColor(UIColor().buttonColor(), for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.backgroundColor = .none
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        title.contentMode = .center
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 20, weight: .light)
        title.textColor = UIColor().titleColor()
        title.backgroundColor = UIColor().bgColor()
        title.isHidden = false
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let listSubtitleResult: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var loadingIndicator = NVActivityIndicatorView(frame: .zero)
    private var listSubtitle = [Dictionary<String, String>]()
    var subtitleManager: SubtitleManager?
    // MARK:- SUPER VIEW DID LOAD
    
    override func viewDidLoad() {
        subtitleManager?.delegate = self
        super.viewDidLoad()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupTitleBar()
        setupListSubtitleResult()
        // Do any additional setup after loading the view.
    }
    
    @objc func handleCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setupTitleBar() {
        view.addSubview(topBar)
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 100)
        ])
        topBar.addSubview(closeButton)
        topBar.addSubview(titleLabel)
        topBar.bringSubviewToFront(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topBar.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 10),
            
            titleLabel.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -20),
        ])
    }
    
    func setupListSubtitleResult() {
        listSubtitleResult.tableFooterView = UIView()
        listSubtitleResult.delegate = self
        listSubtitleResult.dataSource = self
        listSubtitleResult.register(SubtitleCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(listSubtitleResult)
        NSLayoutConstraint.activate([
            listSubtitleResult.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            listSubtitleResult.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listSubtitleResult.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listSubtitleResult.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showLoadingIndicator() {
        let frame = CGRect(x: view.center.x - 25, y: view.center.y - 25, width: 50, height: 50)
        loadingIndicator = NVActivityIndicatorView(frame: frame, type: .ballTrianglePath, color: UIColor().titleColor(), padding: 0)
        loadingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
}


extension SubtitleSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSubtitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubtitleCell
        cell.subtitleName.text = listSubtitle[indexPath.row]["title"]
        return cell
    }
    
    
}

extension SubtitleSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let linkToDownload = listSubtitle[indexPath.row]["link"] {
            print(linkToDownload)
            subtitleManager?.getLinkDownloadSubtitle(url: linkToDownload)
        }
        
    }
}

extension SubtitleSelectViewController: SubtitleManagerDelegate {
    
    func getListSubtitleSuccess(list: [Dictionary<String, String>]) {
        hideLoadingIndicator()
        listSubtitle = list
        listSubtitleResult.reloadData()
    }
    
    func getListFailed() {
        print("getListSubtitleFailed")
        hideLoadingIndicator()
    }
    
    func downloadSubtitleSuccess(fileURL: URL) {
        print("downloadSubtitleSuccess")
        subtitleManager?.extractSubtitle(fileURL: fileURL)
    }
    
    func downloadSubtitleFailed() {
        print("downloadSubtitleFailed")
    }
    
    func extractSubtitleSuccess(filePath: String) {
        print(filePath)
        self.dismiss(animated: true, completion: nil)
    }
    
    func extractSubtitleFailed() {
        print("extractSubtitleFailed")
    }
}
