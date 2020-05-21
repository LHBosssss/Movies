//
//  FshareAccountInfomation.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/4/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import RealmSwift

class FshareAccountInformationModel: Object {
    @objc dynamic var name = ""
    @objc dynamic var phone = ""
    @objc dynamic var type = ""
    @objc dynamic var gender = ""
    @objc dynamic var expire = 0

}
