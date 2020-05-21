//
//  MovieInformationManager.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/7/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

protocol MovieManagerDelegate {
    func getHotMoviesSuccess(listMovies: [MovieModel])
    func getHotMoviesFailed()
    
    func getMovieInformationSuccess(movie: MovieInformationModel)
    func getMovieInformationFailed()
}

class ListMovieManager {
    
    var delegate: MovieManagerDelegate?
    
    func getHotMovie(){
        print("Get Hot movies \(Thread.current)")
        var listMovies = [MovieModel]()
        let requestURL = "https://www.thuvienaz.net"
        AF.request(requestURL).responseString { (response) in
            do {
                let html = try response.result.get()
                let doc: Document = try SwiftSoup.parse(html)
                var divElement = try doc.getElementsByTag("body").first()
                divElement = try doc.getElementById("featured-titles")
                let classElements = try divElement?.select("article")
                for element in classElements! {
                    let item = MovieModel()
                    // Get Movie ID
                    let id = try element.attr("id").split(separator: "-").last
                    item.id = String(id ?? "")
                    
                    // Get Poster Image
                    let image = try element.select("img").attr("src")
                    item.image = image.replacingOccurrences(of: "-225x315", with: "")
                    
                    // Get Link
                    let link = try element.select("a").first()!.attr("href")
                    item.link = link
                    
                    // Get Title
                    let rawTitle = try element.getElementsByClass("data dfeatur").first()
                    let title = try rawTitle!.select("h3").text()
                    item.title = title
                    
                    // Get Year
                    let year = try rawTitle!.select("span").text()
                    item.year = year
                    // Append to Movie Array
                    listMovies.append(item)
                }
                self.delegate?.getHotMoviesSuccess(listMovies: listMovies)
            } catch Exception.Error(let type, let message) {
                print(type)
                print(message)
                self.delegate?.getHotMoviesFailed()
            } catch {
                print("error")
                self.delegate?.getHotMoviesFailed()
            }
        }
    }
    
    func getMovieInformation(link: String) {
        print("Get Movie Information \(Thread.current)")
        let requestURL = link
        AF.request(requestURL).responseString { (response) in
            do {
                let html = try response.result.get()
                let doc: Document = try SwiftSoup.parse(html)
                var divElement = try doc.getElementsByTag("body").first()
                divElement = try doc.getElementById("single")
                let contentElement = try divElement?.select("content")
                
                let item = MovieInformationModel()
                guard let content = contentElement!.first() else {return}
                
                // Get Movie Trailer
                let linkTrailer = try content.getElementById("ytplayer")!.attr("src")
                item.linkTrailer = linkTrailer
                
                // Get Raw Data
                let extra = try content.getElementsByClass("data").first()!
                
                // Get Vietnamese Title
                let viTitle = try extra.select("h1").text()
                item.viTitle = viTitle
                
                // Get English Title
                let enTitle = try extra.select("h2").text()
                item.enTitle = enTitle
                
                // Get Year
                let year = try extra.getElementsByClass("date").text()
                item.year = year
                
                // Get Country
                let country = try extra.getElementsByClass("country").text()
                item.country = country
                
                // Get Total Time
                let total = try extra.getElementsByClass("runtime").text()
                item.total = total
                               
                // Get Language
                let language = try extra.getElementsByClass("lag").text()
                item.language = language
                
                // Get Genre
                var genres = [String]()
                let movieGenres = try content.select("a")
                for genre in movieGenres {
                    let gr = try genre.text()
                    genres.append(gr)
                }
                item.genres = genres
                
                // Append to Movie Array
                self.delegate?.getMovieInformationSuccess(movie: item)
            } catch Exception.Error(let type, let message) {
                print(type)
                print(message)
                self.delegate?.getMovieInformationFailed()
            } catch {
                print("error")
                self.delegate?.getMovieInformationFailed()
            }
        }
    }
    
}
