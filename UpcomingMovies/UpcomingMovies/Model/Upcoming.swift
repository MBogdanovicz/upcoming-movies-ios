//
//  Upcoming.swift
//  UpcomingMovies
//
//  Created by Marcelo Bogdanovicz on 19/04/17.
//  Copyright © 2017 Capivara EC. All rights reserved.
//

import UIKit
import ObjectMapper

class Upcoming: Mappable {

    var page: Int!
    var results: [Movie]!
    var totalPages: Int!

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        page <- map["page"]
        results <- map["results"]
        totalPages <- map["total_pages"]
    }
}
