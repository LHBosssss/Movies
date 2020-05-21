//
//  FshareLinkManager.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/9/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol FshareLinkManagerDelegate {
    func getFolderLinkSuccess(links: Dictionary<String , String>)
    func getDirectLinkSuccess(link: String, title: String)
    func getLinkFailed()
}

class FshareLinkManager {
    
    var delegate: FshareLinkManagerDelegate?
    
    func getDirectLink(session: String, token: String, link: String, title: String) {
        let requestURL = URL(string: "https://api.fshare.vn/api/session/download")
        let header: HTTPHeaders = [
            "Referer" : "www.fshare.vn",
            "User-Agent": "okhttp/3.6.0",
            "Cookie" : "session_id=\(session)"
        ]
        
        let data = [
            "token": token,
            "url": link
        ]
        AF.request(requestURL!, method: .post,parameters: data,encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let directLink = json["location"].stringValue
                if directLink == "" {
                    self.delegate?.getLinkFailed()
                    return
                }
                self.getIPLink(url: directLink, title: title)
                return
            case .failure(let error):
                print(error)
                self.delegate?.getLinkFailed()
            }
        }
    }
    
    
    
    func getFolderLink(session: String, token: String, link: String) {
        let requestURL = URL(string: "https://api.fshare.vn/api/fileops/getFolderList")
        let header: HTTPHeaders = [
            "Cookie" : "session_id=\(session)"
        ]
        let data = [
            "token": token,
            "url": link
        ]
        AF.request(requestURL!, method: .post, parameters: data, encoding: JSONEncoding.default ,headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                var listLinktoReturn = Dictionary<String , String>()
                let json = JSON(value)
                let jsonarr = json.arrayValue
                for item in jsonarr {
                    let title = item["ftitle"].stringValue
                    let link = item["furl"].stringValue
                    listLinktoReturn[title] = link
                }
                self.delegate?.getFolderLinkSuccess(links: listLinktoReturn)
                return
            case .failure(let error):
                print(error)
                self.delegate?.getLinkFailed()
            }
        }
    }
    
    
    func getIPLink(url: String, title: String) {
            let originalURL = url
            let hostadd = String(originalURL.split(separator: "/")[1])
            let host = CFHostCreateWithName(nil, hostadd as CFString).takeRetainedValue()
            CFHostStartInfoResolution(host, .addresses, nil)
            var success: DarwinBoolean = false
            if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray? {
                if case let theAddress as NSData = addresses.lastObject
                {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                                   &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                        let numAddress = String(cString: hostname)
                        let finalURL = originalURL.replacingOccurrences(of: hostadd, with: numAddress)
                        self.delegate?.getDirectLinkSuccess(link: finalURL, title: title)
                    }
                }
            }
        }
}
