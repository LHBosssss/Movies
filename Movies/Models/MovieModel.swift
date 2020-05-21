//
//  MovieModel.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/7/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import Foundation

class MovieModel {
    var id = ""
    var link = ""
    var title = ""
    var year = ""
    var image = ""
    
    func printMovieItem() {
        print("id = \(self.id)")
        print("link = \(self.link)")
        print("title = \(self.title)")
        print("year = \(self.year)")
        print("image = \(self.image)")

    }
}
