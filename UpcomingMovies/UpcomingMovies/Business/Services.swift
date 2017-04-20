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

            let mapper = Mapper<Genre>()
            let genres = mapper.mapArray(JSONString: data as String)!

            Constants.genres = genres

            return Observable.empty()
        } else {
            return RestAPI.getAllGenres(language: Utils.getLanguage()).map({ genres -> Void in

                Utils.saveRequestCache(object: genres, cacheKey: Constants.genresCacheKey)
                Constants.genres = genres
            })
        }
    }

    class func loadMovies(page: Int) -> Observable<Upcoming> {
        return RestAPI.loadMovies(page: page, language: Utils.getLanguage())
    }

    class func loadMovieDetails(_ movieId: Int) -> Observable<Movie> {
        return RestAPI.loadMovieDetails(movieId, language: Utils.getLanguage())
    }

    class func searchMovies(page: Int, query: String) -> Observable<Upcoming> {
        return RestAPI.searchMovies(page: page, query: query, language: Utils.getLanguage())
    }
}
