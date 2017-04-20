//
//  RestAPI.swift
//  UpcomingMovies
//
//  Created by Marcelo Bogdanovicz on 19/04/17.
//  Copyright © 2017 Capivara EC. All rights reserved.
//

import Foundation
import RxSwift

class RestAPI: NSObject {

    class func getAllGenres(language: String) -> Observable<[Genre]> {

    }

    class func loadMovies(page: Int, language: String) -> Observable<Upcoming> {

    }

    class func loadMovieDetails(_ movieId: Int) -> Observable<Movie> {

    }

    class func searchMovies(page: Int, query: String, language: String) -> Observable<Upcoming> {
        
    }
}
