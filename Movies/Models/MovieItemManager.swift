//
//  ItemMovieManager.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/7/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

protocol MovieItemManagerDelegate {
    
    func getMovieInformationSuccess(movieItem: MovieInformationModel)
    func getMovieInformationFailed()
    
    func getMovieLinkSuccess(links: Dictionary<String , String>)
    func getMovieLinkFailed()
}

class MovieItemManager {
    var delegate: MovieItemManagerDelegate?
    func getMovieInformation(link: String) {
        let requestURL = link
        AF.request(requestURL).responseString { (response) in
            do {
                let html = try response.result.get()
                let doc: Document = try SwiftSoup.parse(html)
                var divElement = try doc.getElementsByTag("body").first()
                divElement = try doc.getElementById("single")
                let contentElement = try divElement?.getElementsByClass("content")
                
                let item = MovieInformationModel()
                guard let content = contentElement!.first() else {return}
                
                // Get Movie ID
                let id = try content.getElementById("post_ID")!.attr("value")
                item.id = id
                                
                // Get Raw Data
                let data = try content.getElementsByClass("data").first()!
                
                // Get Vietnamese Title
                let viTitle = try data.select("h1").text()
                item.viTitle = viTitle
                
                // Get English Title
                let enTitle = try data.select("h2").text()
                item.enTitle = enTitle
                
                // Get Year
                let year = try data.getElementsByClass("date").text()
                item.year = year
                
                // Get Country
                let country = try data.getElementsByClass("country").text()
                item.country = country
                
                // Get Total Time
                let total = try data.getElementsByClass("runtime").text()
                item.total = total

                // Get Genre
                var genres = [String]()
                let movieGenres = try data.select("a")
                for genre in movieGenres {
                    let gr = try genre.text()
                    genres.append(gr)
                }
                item.genres = genres
                
                // Get Actors
                var actors = [String]()
                let actorsClass = try content.getElementById("cast")!
                let actorsArray = try actorsClass.select("li")
                for actor in actorsArray {
                    let act = try actor.text()
                    actors.append(act)
                }
                item.actors = actors
                
                // Get Raw Description
                let rawDescription = try content.getElementById("info")!
                
                // Get Description
                let description = try rawDescription.getElementsByClass("cnnn").text()
                item.description = description.replacingOccurrences(of: "ThuVienAz.net", with: "")
                
                // Get Image Gallery
                var galleryLinks = [String]()
                let galleryClass = try content.getElementById("lightgallery")
                guard let galleryArray = try galleryClass?.select("a") else {return}
                for image in galleryArray {
                    let img = try image.attr("href")
                    galleryLinks.append(img)
                }
                item.images = galleryLinks
                
                // Get IMDB
                let imdb = try rawDescription.getElementById("repimdb")?.select("strong").first()?.text()
                item.imdb = imdb ?? "0.0"
                // Append to Movie Array
                self.delegate?.getMovieInformationSuccess(movieItem: item)
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
    
    func getMovieLink(id: String) {
        guard let url = URL(string: "https://www.thuvienaz.net/convert-video?id=\(id)") else { return }
        var urlRequest = URLRequest(url: url)
        print(url)
        urlRequest.timeoutInterval = TimeInterval(exactly: 10)!
        AF.request(urlRequest).responseString { (response) in
            do {
                var listLinktoReturn = Dictionary<String , String>()
                let html = try response.result.get()
                let doc: Document = try SwiftSoup.parse(html)
                // Get Year, Country, Runtime
                let tableClass = try doc.getElementsByClass("post_table").first()
                let tbody = try tableClass?.select("tbody").first()
                let listLink = try tbody?.getElementsByTag("tr")
                if let list = listLink {
                    for link in list {
                        let title = try link.text()
                        let link = try link.select("input").attr("value")
                        listLinktoReturn[title] = link
                    }
                    self.delegate?.getMovieLinkSuccess(links: listLinktoReturn)
                }
            } catch Exception.Error(let type, let message) {
                print("Get Movie Extra Information Error: \(type) \(message)")
                self.delegate?.getMovieLinkFailed()
            } catch {
                print("Get Movie Extra Information Error")
                self.delegate?.getMovieLinkFailed()
            }
        }
    }
}
