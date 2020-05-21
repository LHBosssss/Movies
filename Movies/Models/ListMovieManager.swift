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

protocol ListMovieManagerDelegate {
    func getMoviesSuccess(listMovies: [MovieModel])
    func getMoviesFailed()
}

class ListMovieManager {
    
    var delegate: ListMovieManagerDelegate?
    
    func getHotMovie(){
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
                self.delegate?.getMoviesSuccess(listMovies: listMovies)
            } catch Exception.Error(let type, let message) {
                print(type)
                print(message)
                self.delegate?.getMoviesFailed()
            } catch {
                print("error")
                self.delegate?.getMoviesFailed()
            }
        }
    }
    
    
    func getGenreMovie(genre: String){
        if genre == "hot" {
            getHotMovie()
            return
        }
        var requestURL = "https://www.thuvienaz.net/genre/" + genre
        if genre == "trending" {
            requestURL = "https://www.thuvienaz.net/trending?get=movies"
        }
        var listMovies = [MovieModel]()
        AF.request(requestURL).responseString { (response) in
            do {
                let html = try response.result.get()
                let doc: Document = try SwiftSoup.parse(html)
                var divElement = try doc.getElementsByTag("body").first()
                divElement = try doc.getElementById("contenedor")
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
                    let rawTitle = try element.getElementsByClass("data").first()
                    let title = try rawTitle!.select("h3").text()
                    item.title = title
                    
                    // Get Year
                    let year = try rawTitle!.select("span").text()
                    item.year = year
                    // Append to Movie Array
                    listMovies.append(item)
                }
                self.delegate?.getMoviesSuccess(listMovies: listMovies)
            } catch Exception.Error(let type, let message) {
                print(type)
                print(message)
                self.delegate?.getMoviesFailed()
            } catch {
                print("error")
                self.delegate?.getMoviesFailed()
            }
        }
    }
}
