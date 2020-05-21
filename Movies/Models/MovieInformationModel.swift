//
//  MovieInformationModel.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/7/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import Foundation

class MovieInformationModel {
    var id = ""
    var linkTrailer = ""
    var viTitle = ""
    var enTitle = ""
    var year = ""
    var country = ""
    var total = ""
    var genres = [String]()
    var actors = [String]()
    var description = ""
    var images = [String]()
    var imdb = ""
    
    func printMovieItem() {
        print("id = \(self.id)")
        print("linkTrailer = \(self.linkTrailer)")
        print("viTitle = \(self.viTitle)")
        print("enTitle = \(self.enTitle)")
        print("year = \(self.year)")
        print("country = \(self.country)")
        print("total = \(self.total)")
        print("genres = \(self.genres)")
        print("actors = \(self.actors)")
        print("description = \(self.description)")
        print("images = \(self.images)")
        print("imdb = \(self.imdb)")

    }
}
