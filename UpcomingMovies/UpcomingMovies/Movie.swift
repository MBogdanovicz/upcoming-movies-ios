//
//  Movie.swift
//  UpcomingMovies
//
//  Created by Marcelo Bogdanovicz on 19/04/17.
//  Copyright © 2017 Capivara EC. All rights reserved.
//

import UIKit
import ObjectMapper

class Movie: Mappable {

    var posterPath: String!
    var posterUrl: URL?
    var overview: String!
    var releaseDate: String!
    var id: Int!
    var originalTitle: String!
    var title: String!
    var genreIds: [Int]!
    var genres: [Genre]!//var genres = [Genre]()

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        posterPath <- map["poster_path"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
        id <- map["id"]
        originalTitle <- map["original_title"]
        title <- map["title"]
        genreIds <- map["genre_ids"]
        genres <- map["genres"]

        posterUrl = Utils.getPosterUrl(posterPath: posterPath)
    }
}
