//
//  Services.swift
//  UpcomingMovies
//
//  Created by Marcelo Bogdanovicz on 19/04/17.
//  Copyright © 2017 Capivara EC. All rights reserved.
//

import Foundation
import RxSwift
import AwesomeCache
import ObjectMapper

class Services {

    class func getAllGenres() -> Observable<Void> {

        if let cache = Utils.getRequestCache(),
            let data = cache.object(forKey: Constants.genresCacheKey) {

            let mapper = Mapper<[Genre]>()
            let genres = mapper.map(JSONString: data as String)!

            Constants.genres = genres

            return Observable.empty()
        } else {
            return RestAPI.getAllGenres(language: Utils.getLanguage()).map({ observer -> Void in

                Utils.saveRequestCache(object: observer, key: Constants.genresCacheKey)
                Constants.genres = observer
            })
        }
    }

    class func loadMovies(page: Int = 1) -> Observable<Upcoming> {
        return RestAPI.loadMovies(page: page, language: Utils.getLanguage())
    }

    class func loadMovieDetails(_ movieId: Int) -> Observable<Movie> {
        return RestAPI.loadMovieDetails(movieId)
    }

    class func searchMovies(page: Int = 1, query: String) -> Observable<Upcoming> {
        return RestAPI.searchMovies(page: page, query: query, language: Utils.getLanguage())
    }
}
