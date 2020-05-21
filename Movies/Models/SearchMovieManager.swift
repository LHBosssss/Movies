//
//  SearchMovieManager.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/14/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol SearchMovieManagerDelegate {
    func searchMovieSuccess(listMovies: [MovieModel])
    func searchMovieFailed()
}

class SearchMovieManager {
    
    var delegate: SearchMovieManagerDelegate?
    
    func searchMovie(title: String) {
        var listMovies = [MovieModel]()
        search(title: title, start: 1) { (data) in
            listMovies.append(contentsOf: data)
            self.search(title: title, start: 11) { (data) in
                listMovies.append(contentsOf: data)
                self.delegate?.searchMovieSuccess(listMovies: listMovies)
            }
        }
    }
    
    func search(title: String, start: Int, completion: @escaping ([MovieModel]) -> Void) {
        var listMovies = [MovieModel]()
        let safeText = title.folding(options: .diacriticInsensitive, locale: .current)
        let safeTitle = safeText.replacingOccurrences(of: " ", with: "%20")
        let requestURL = "https://www.googleapis.com/customsearch/v1?key=AIzaSyAAfxtJoJfglbvaQp-Q4D07QWJMPr-R6d8&cx=005062995389025341422:gn1ilesmcts&q=\(safeTitle)&start=\(start)"
        
        AF.request(requestURL, method: .get).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let responseData = JSON(value)
                let itemData = responseData["items"]
                let itemDataArray = itemData.arrayValue
                for item in itemDataArray {
                    let movieItem = MovieModel()
                    movieItem.link = item["link"].stringValue
                    
                    let metatag = item["pagemap"]["metatags"][0]
                    
                    movieItem.title = metatag["og:title"].stringValue
                    
                    movieItem.year = metatag["article:tag"].stringValue
                    
                    movieItem.image = metatag["og:image"].stringValue
                    
                    movieItem.printMovieItem()
                    
                    if movieItem.image == "" {
                        movieItem.image = item["pagemap"]["cse_image"][0]["src"].stringValue
                        if movieItem.image == "" {
                            movieItem.image = "https://www.thuvienaz.net/wp-content/uploads/2018/08/thuvienaz.png"
                        }
                    }
                    
                    movieItem.link.contains("/phim/") ? listMovies.append(movieItem) : print("Not Link Movie")

                }
                completion(listMovies)
            case .failure(let value):
                print(value)
                self.delegate?.searchMovieFailed()
                completion(listMovies)
            }
        }
    }
    
}
