//
//  SubtitleManager.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/13/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup
import Zip

@objc protocol SubtitleManagerDelegate {
    @objc optional func getListMovieSuccess(list: [Dictionary<String, String>])
    
    @objc optional func getListSubtitleSuccess(list: [Dictionary<String, String>])
    
    @objc optional func getListFailed()
    
    @objc optional func downloadSubtitleSuccess(fileURL: URL)
    
    @objc optional func downloadSubtitleFailed()
    
    @objc optional func extractSubtitleSuccess(filePath: String)
    
    @objc optional func extractSubtitleFailed()

}

@objc protocol SelectedSubtitleDelegate {
    @objc optional func didSelectSubtitle(filePath: String)
}

class SubtitleManager {
    var delegate: SubtitleManagerDelegate?
    var selectedDelegate: SelectedSubtitleDelegate?
    var selectedDelegate2: SelectedSubtitleDelegate?
    
    func getListMovie(title: String) {
        let requestURL = "https://subscene.com/subtitles/searchbytitle?query=\(title)"
        let headers: HTTPHeaders = [
            "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:41.0) Gecko/20100101 Firefox/41.0",
            "Referer" : "https://subscene.com",
            "Accept-encoding" : "gzip",
            "Cookie" : "LanguageFilter=45"
        ]
        
        AF.request(requestURL, method: .get, headers: headers).responseString { (response) in
            do {
                var listMovie = [Dictionary<String, String>]()
                let result = try response.result.get()
                let doc: Document = try SwiftSoup.parse(result)
                
                if let divSearchResult = try doc.getElementsByClass("search-result").first() {
                    let list = try divSearchResult.getElementsByTag("li")
                    for item in list {
                        if let title = try item.select("a").first()?.text(), let link = try item.select("a").first()?.attr("href"){
                            var subtitleItem = Dictionary<String, String>()
                            subtitleItem["title"] = title
                            subtitleItem["link"] = link
                            listMovie.append(subtitleItem)
                        }
                    }
                    print(listMovie)
                    if listMovie.count == 0 {
                        self.delegate?.getListFailed?()
                        return
                    }
                    self.delegate?.getListMovieSuccess?(list: listMovie)
                }
            }
            catch (let error) {
                self.delegate?.getListFailed?()
                print("First Data Error: \(error)")
            }
        }
    }
    
    func getListSubtitle(link: String) {
        let link = link
        let requestURL = "https://subscene.com\(link)"
        let headers: HTTPHeaders = [
            "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:41.0) Gecko/20100101 Firefox/41.0",
            "Referer" : "https://subscene.com",
            "Accept-encoding" : "gzip",
            "Cookie" : "LanguageFilter=45"
        ]
        
        AF.request(requestURL, method: .get, headers: headers).responseString { (response) in
            do {
                var listSubtitle = [Dictionary<String, String>]()
                let result = try response.result.get()
                let doc: Document = try SwiftSoup.parse(result)
                guard let table = try doc.getElementsByTag("table").first() else { return }
                let tbody = try table.select("tbody")
                let list = try tbody.select("tr")
                for tr in list {
                    guard let td = try tr.select("td").first() else { return }
                    guard let a = try td.select("a").first() else { return }
                    if let title = try a.select("span").last()?.text() {
                        let link = try a.attr("href")
                        var subtitleItem = Dictionary<String, String>()
                        subtitleItem["title"] = title
                        subtitleItem["link"] = link
                        listSubtitle.append(subtitleItem)
                    }
                }
                if listSubtitle.count == 0 {
                    self.delegate?.getListFailed?()
                    return
                }
                print(listSubtitle)
                self.delegate?.getListSubtitleSuccess?(list: listSubtitle)
            }
            catch (let error) {
                print("Fetch List Subtitle Error: \(error)")
                self.delegate?.getListFailed?()
            }
        }
    }
    
    func getLinkDownloadSubtitle(url: String) {
        var linkToDownload = ""
        let requestURL = "https://subscene.com\(url)"
        let headers: HTTPHeaders = [
            "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:41.0) Gecko/20100101 Firefox/41.0",
            "Referer" : "https://subscene.com",
            "Accept-encoding" : "gzip",
            "Cookie" : "LanguageFilter=45"
        ]
        
        AF.request(requestURL, method: .get, headers: headers).responseString { (response) in
            do {
                let result = try response.result.get()
                let doc: Document = try SwiftSoup.parse(result)
                
                let divDownload = try doc.getElementsByClass("download").first()
                let alink = try divDownload?.select("a")
                let link = try alink?.attr("href")
                if let link = link {
                    linkToDownload = "https://subscene.com\(link)"
                    self.downloadSubtitle(url: linkToDownload)
                }
            }
            catch (let error) {
                self.delegate?.downloadSubtitleFailed?()
                print("Get Link Download Subtitle Error: \(error)")
            }
        }
    }
    
    func downloadSubtitle(url: String) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("SubtitleFolder")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask, options: .removePreviousFile)
        let fm = FileManager.default
        let documentPath = documentsDirectory + "/SubtitleFolder"
        do {
            try fm.removeItem(atPath: documentPath)
        } catch {
            print("Remove Item Error")
        }
        AF.download(url, to: destination ).responseData { response in
            let filename = response
            print(filename)
            if let fileURL = response.fileURL {
                print(fileURL)
                self.delegate?.downloadSubtitleSuccess?(fileURL: fileURL)
                return
            }
            self.delegate?.downloadSubtitleFailed?()
        }
    }
    
    func extractSubtitle(fileURL: URL) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("SubtitleFolder")
        
        // Remove Old Files
        let fm = FileManager.default
        let documentPath = documentsDirectory + "/SubtitleFolder"
        do {
            try fm.removeItem(atPath: documentPath)
        } catch {
            print("Remove Item Error")
        }
        do {
            try Zip.unzipFile(fileURL, destination: dataPath, overwrite: true, password: nil, progress: { (progress) -> () in
                print(progress)
            }) // Unzip
            try fm.removeItem(at: fileURL)
        }
        catch {
            delegate?.downloadSubtitleFailed?()
            print("Something went wrong")
        }
        
        // Get file in SubtitleFolder
        do {
            let allfile = try fm.contentsOfDirectory(atPath: documentPath)
            print(allfile)
            var listSubtitle = [String]()
            for file in allfile {
                let title = file
                let url = documentPath + "/" + title
                let subtitleItem: String = url
                listSubtitle.append(subtitleItem)
            }
            print("Count = \(listSubtitle.count) - \(listSubtitle)")
            if listSubtitle.count == 1 {
                self.delegate?.extractSubtitleSuccess?(filePath: listSubtitle[0])
                self.selectedDelegate?.didSelectSubtitle?(filePath: listSubtitle[0])
                self.selectedDelegate2?.didSelectSubtitle?(filePath: listSubtitle[0])
            } else {
                print("More than 1")
            }
        } catch {
            print("Get file error")
        }
    }
}
