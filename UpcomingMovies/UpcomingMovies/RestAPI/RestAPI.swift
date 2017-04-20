//
//  RestAPI.swift
//  UpcomingMovies
//
//  Created by Marcelo Bogdanovicz on 19/04/17.
//  Copyright © 2017 Capivara EC. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class RestAPI: NSObject {

    private static let apiKey = "1f54bd990f1cdfb230adb312546d765d"

    class func getAllGenres(language: String) -> Observable<[Genre]> {

        return Observable<[Genre]>.create { observer in

            var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=\(language)")!,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "GET"

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error ?? "error")
                    observer.onError(error!)
                } else {

                    let mapper = Mapper<Genres>()

                    guard let genres = mapper.map(JSONString: String(data: data!, encoding: .utf8)!) else {
                        observer.onError(NSError(domain: "", code: 1, userInfo: nil))
                        return
                    }

                    observer.onNext(genres.genres)
                    observer.onCompleted()
                }
            })
            
            dataTask.resume()

            return Disposables.create()
        }
    }

    class func loadMovies(page: Int, language: String) -> Observable<Upcoming> {

        return Observable<Upcoming>.create { observer in

            var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/upcoming?page=\(page)&language=\(language)&api_key=\(apiKey)")!,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "GET"

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error ?? "error")
                    observer.onError(error!)
                } else {

                    let mapper = Mapper<Upcoming>()

                    guard let upcoming = mapper.map(JSONString: String(data: data!, encoding: .utf8)!) else {
                        observer.onError(NSError(domain: "", code: 1, userInfo: nil))
                        return
                    }

                    observer.onNext(upcoming)
                    observer.onCompleted()
                }
            })

            dataTask.resume()

            return Disposables.create()
        }
    }

    class func loadMovieDetails(_ movieId: Int, language: String) -> Observable<Movie> {

        return Observable<Movie>.create { observer in

            var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(apiKey)&language=\(language)")!,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "GET"

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error ?? "error")
                    observer.onError(error!)
                } else {

                    let mapper = Mapper<Movie>()

                    guard let movie = mapper.map(JSONString: String(data: data!, encoding: .utf8)!) else {
                        observer.onError(NSError(domain: "", code: 1, userInfo: nil))
                        return
                    }

                    observer.onNext(movie)
                    observer.onCompleted()
                }
            })

            dataTask.resume()

            return Disposables.create()
        }
    }

    class func searchMovies(page: Int, query: String, language: String) -> Observable<Upcoming> {

        return Observable<Upcoming>.create { observer in

            var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=\(language)&page=\(page)&query=\(query)")!,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "GET"

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error ?? "error")
                    observer.onError(error!)
                } else {

                    let mapper = Mapper<Upcoming>()

                    guard let upcoming = mapper.map(JSONString: String(data: data!, encoding: .utf8)!) else {
                        observer.onError(NSError(domain: "", code: 1, userInfo: nil))
                        return
                    }

                    observer.onNext(upcoming)
                    observer.onCompleted()
                }
            })
            
            dataTask.resume()
            
            return Disposables.create()
        }
    }
}
