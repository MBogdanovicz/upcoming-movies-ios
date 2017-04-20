//
//  MoviesListTableViewController.swift
//  UpcomingMovies
//
//  Created by Marcelo Bogdanovicz on 19/04/17.
//  Copyright © 2017 Capivara EC. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class MoviesListTableViewController: UITableViewController {

    private let bag = DisposeBag()
    private var movies = [Movie]()
    private var totalPages: Int!
    private var currentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        loadGenres()
    }

    private func loadGenres() {
        _ = Services.getAllGenres().observeOn(MainScheduler.instance)
            .subscribe(
                onCompleted: {
                self.loadMovies()
            }).addDisposableTo(bag)
    }

    private func loadMovies() {
        _ = Services.loadMovies().observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { upcoming in
                    self.movies = upcoming.results
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
            },
                onError: { err in
                    self.refreshControl?.endRefreshing()
            }).addDisposableTo(bag)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieListCell", for: indexPath)

        let poster = cell.viewWithTag(1) as! UIImageView
        let releaseDate = cell.viewWithTag(2) as! UILabel
        let title = cell.viewWithTag(3) as! UILabel
        let genres = cell.viewWithTag(4) as! UILabel

        let movie = movies[indexPath.row]

        if let posterUrl = movie.posterUrl {
            poster.sd_setImage(with: posterUrl)
        } else {
            poster.image = nil
        }

        releaseDate.text = Utils.formatDate(movie.releaseDate, dateStyle: .short)
        title.text = movie.title
        genres.text = Utils.getGenres(genreIds: movie.genreIds).joined(separator: ", ")

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MovieDetailsSegue", sender: indexPath.row)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieDetail = segue.destination as! MovieDetailTableViewController
        let movieIndex = sender as! Int

        movieDetail.movie = movies[movieIndex]
    }

}
