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
        if let cache = getRequestCache() {
            cache.setObject(strJSON as NSString, forKey: cacheKey, expires: .seconds(Constants.requestsCacheTTL))
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
}

class Constants {

    static var genres: [Genre]!
    static let genresCacheKey = "GENRES_CACHE_KEY"
    static let requestsCacheTTL: TimeInterval = 60 * 60 * 24 * 5 //5 days
}
