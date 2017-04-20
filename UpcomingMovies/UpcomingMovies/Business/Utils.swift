//
//  Utils.swift
//  UpcomingMovies
//
//  Created by Marcelo Bogdanovicz on 19/04/17.
//  Copyright © 2017 Capivara EC. All rights reserved.
//

import Foundation
import AwesomeCache
import ObjectMapper

class Utils {

    class func getLanguage() -> String {
        return Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
    }

    class func getRequestCache() -> Cache<NSString>? {
        return try? Cache<NSString>(name: "UPCOMING_MOVIES_CACHE_KEY")
    }

    class func saveRequestCache<T>(object: T, cacheKey: String) where T:BaseMappable {
        let mapper = Mapper<T>()
        let strJSON = mapper.toJSONString(object)! as NSString

        setCacheObject(strJSON: strJSON, cacheKey: cacheKey)
    }

    class func saveRequestCache<T>(object: [T], cacheKey: String) where T:BaseMappable {
        let mapper = Mapper<T>()
        let strJSON = mapper.toJSONString(object)!

        Utils.setCacheObject(strJSON: strJSON as NSString, cacheKey: cacheKey)
    }

    private class func setCacheObject(strJSON: NSString, cacheKey: String) {
        if let cache = getRequestCache() {
            cache.setObject(strJSON, forKey: cacheKey, expires: .seconds(Constants.requestsCacheTTL))
        }
    }

    class func formatDate(_ strDate: String, dateStyle: DateFormatter.Style = .long) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: strDate) else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle

        return formatter.string(from: date)
    }

    class func getPosterUrl(posterPath: String) -> URL? {
        return URL(string: Constants.posterBaseUrl + posterPath)
    }

    class func getGenres(genreIds: [Int]) -> [String] {
        var genresStr = [String]()

        for id in genreIds {
            for genre in Constants.genres {
                if genre.id == id {
                    genresStr.append(genre.name)
                    break
                }
            }
        }

        return genresStr
    }

    class func getGenres(genres: [Genre]) -> [String] {
        var genreStr = [String]()

        for genre in genres {
            genreStr.append(genre.name)
        }

        return genreStr
    }
}

class Constants {

    static var genres = [Genre]()
    static let genresCacheKey = "GENRES_CACHE_KEY"
    static let requestsCacheTTL: TimeInterval = 60 * 60 * 24 * 5 //5 days
    static let posterBaseUrl = "http://image.tmdb.org/t/p/w185"
}
