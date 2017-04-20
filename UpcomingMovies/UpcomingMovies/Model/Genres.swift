//
//  Genres.swift
//  UpcomingMovies
//
//  Created by Marcelo Bogdanovicz on 20/04/17.
//  Copyright © 2017 Capivara EC. All rights reserved.
//

import Foundation
import ObjectMapper

class Genres: Mappable {

    var genres: [Genre]!

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        genres <- map["genres"]
    }
}
