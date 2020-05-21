//
//  MovieItemLinksTable.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/9/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import RealmSwift
import NVActivityIndicatorView

protocol MovieItemLinksViewDelegate {
    func getDirectLinkSuccess(link: String, title: String)
    func getDirectLinkFailed()
}

class MovieItemLinksView: UIView {
    
    var titles : [String]? {
        didSet {
            linksTable.reloadData()
        }
    }
    private let linksTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor().bgColor()
        return table
    }()
    
        private var loadingIndicator = NVActivityIndicatorView(frame: .zero)

    var delegate: MovieItemLinksViewDelegate?
    var listLink = Dictionary<String , String>()
    private var movieLinkManager = FshareLinkManager()

    override init(frame: CGRect) {
        super.init(frame: frame)
        movieLinkManager.delegate = self
        setupLayoutView()
    }
    
    func setupLayoutView() {
        linksTable.tableFooterView = UIView()
        addSubview(linksTable)
        linksTable.dataSource = self
        linksTable.delegate = self
        linksTable.register(LinkCell.self, forCellReuseIdentifier: "LinkCell")
        NSLayoutConstraint.activate([
            linksTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            linksTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            linksTable.topAnchor.constraint(equalTo: topAnchor),
            linksTable.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func showLoadingIndicator() {
        // Add Indicator
        let frame = CGRect(x: center.x - 25, y: center.y - 25, width: 50, height: 50)
        loadingIndicator = NVActivityIndicatorView(frame: frame, type: .ballTrianglePath, color: UIColor().titleColor(), padding: 0)
        addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieItemLinksView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
        cell.linkTitle.text = titles![indexPath.row]
        return cell
    }
}

extension MovieItemLinksView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoadingIndicator()
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath) as! LinkCell
        guard let movieTitle = selectedCell.linkTitle.text else {return}
        let linkToGet = listLink[movieTitle]!
        let isFolderLink = linkToGet.contains("folder")
        let realm = try! Realm()
        let accountData = realm.objects(FshareAccountModel.self)
        let count = accountData.count
        if count > 0 {
            if let session = accountData.first?.sessionID, let token = accountData.first?.token {
                if isFolderLink {
                    movieLinkManager.getFolderLink(session: session, token: token, link: linkToGet)
                } else {
                    movieLinkManager.getDirectLink(session: session, token: token, link: linkToGet, title: movieTitle)
                }
            }
        }
    }
}

extension MovieItemLinksView: FshareLinkManagerDelegate {
    func getFolderLinkSuccess(links: Dictionary<String , String>) {
        hideLoadingIndicator()
        let titleArray: [String] = Array(links.keys)
        titles = titleArray
        listLink.removeAll()
        listLink = links
    }
    
    func getDirectLinkSuccess(link: String, title: String) {
        hideLoadingIndicator()
        self.delegate?.getDirectLinkSuccess(link: link, title: title)
    }
    
    func getLinkFailed() {
        hideLoadingIndicator()
        self.delegate?.getDirectLinkFailed()
    }
}
