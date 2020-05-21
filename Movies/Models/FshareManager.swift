//
//  FshareManager.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/4/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

protocol FshareManagerDelegate {
    func loginSuccess()
    func loginFailed()
    func sessionIsAlive()
    func sessionIsDead()
    func noSessionFound()
}


class FshareManager {
    var delegate: FshareManagerDelegate?
    
    func login(email: String, pass: String) {
        let headers: HTTPHeaders = [
            "Referer" : "www.fshare.vn",
            "User-Agent": "okhttp/3.6.0"
        ]
        let requestURL = "https://api.fshare.vn:443/api/user/login"
        let dataRequest = [
            "app_key" : "L2S7R6ZMagggC5wWkQhX2+aDi467PPuftWUMRFSn",
            "user_email" : email,
            "password" : pass
        ]
        AF.request(requestURL, method: .post, parameters: dataRequest, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let responseData = JSON(value)
                if responseData["msg"] == "Login successfully!" {
                    let session = responseData["session_id"].stringValue
                    let token = responseData["token"].stringValue
                    self.createAccountData(session: session, token: token)
                    self.checkSession(session: session)
                    self.delegate?.loginSuccess()
                    return
                } else {
                    self.delegate?.loginFailed()
                    return
                }
            case .failure(let value):
                print(value)
                self.delegate?.loginFailed()
                return
            }
        }
    }
    
    func createAccountData(session: String, token: String) {
        let realm = try! Realm()
        let accountData = realm.objects(FshareAccountModel.self)
        try! realm.write {
            realm.delete(accountData)
        }
        let data = FshareAccountModel()
        data.sessionID = session
        data.token = token
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {fatalError("Create Account Data Error")}
        self.loadAccountInformation()
    }
    
    func loadSession() {
        let realm = try! Realm()
        let accountData = realm.objects(FshareAccountModel.self)
        let count = accountData.count
        if count > 0 {
            if let session = accountData.first?.sessionID {
                checkSession(session: session)
            }
        } else {
            self.delegate?.noSessionFound()
        }
    }
    
    func checkSession(session: String) {
        let headers: HTTPHeaders = [
            "Referer" : "www.fshare.vn",
            "User-Agent" : "okhttp/3.6.0",
            "Cookie" : "session_id=\(session)"
        ]
            let requestURL = "https://api.fshare.vn/api/user/get"
            AF.request(requestURL, method: .get, headers: headers).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let name = json["name"].stringValue
                    let phone = json["phone"].stringValue
                    let type = json["account_type"].stringValue
                    let gender = json["gender"] == "1" ? "Nam" : "Nữ"
                    let expire = json["expire_vip"].intValue
                    let accountInfo = FshareAccountInformationModel()
                    accountInfo.name = name
                    accountInfo.phone = phone
                    accountInfo.type = type
                    accountInfo.gender = gender
                    accountInfo.expire = expire
                    self.createAccountInformation(acc: accountInfo)
                    if json["account_type"] == "Vip" {
                        self.delegate?.sessionIsAlive()
                        self.loadAccountInformation()
                        return
                    } else {
                        self.delegate?.sessionIsDead()
                        return
                    }
                case .failure(let value):
                    print("Error = \(value)")
                    self.delegate?.sessionIsDead()
                    return
            }
        }
    }
    
    func createAccountInformation(acc: FshareAccountInformationModel) {
            let realm = try! Realm()
            let accountData = realm.objects(FshareAccountInformationModel.self)
            try! realm.write {
                realm.delete(accountData)
            }
            let data = acc
            do {
                try realm.write {
                    realm.add(data)
                }
            } catch {fatalError("Create Account Data Error")}
        }
    
    func loadAccountInformation() {
        let realm = try! Realm()
        let accountData = realm.objects(FshareAccountInformationModel.self)
        let count = accountData.count
        if count > 0 {
            print("Account data\n \(accountData.first)")
        } else {
            print("No account Data")
        }
    }
}
