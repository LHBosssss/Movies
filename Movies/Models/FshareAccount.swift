//
//  FshareAccount.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/4/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import RealmSwift

class FshareAccountData: Object {
    @objc dynamic var sessionID = ""
    @objc dynamic var token = ""
}
