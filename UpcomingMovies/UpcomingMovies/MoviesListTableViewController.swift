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

class MoviesListTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    private let bag = DisposeBag()
    private var movies = [Movie]()
    private var searchedMovies = [Movie]()
    private var totalPages = 0
    private var currentPage = 1
    private var searchingTotalPages = 0
    private var searchingCurrentPage = 1
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl?.addTarget(self, action: #selector(loadMovies), for: .valueChanged)

        setupSearch()
        loadGenres()
    }

    private func setupSearch() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.definesPresentationContext = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        tableView.tableHeaderView = searchController.searchBar
        tableView.contentOffset = CGPoint(x: 0, y: tableView.tableHeaderView?.frame.height ?? 0)
    }

    private func loadGenres() {
        _ = Services.getAllGenres().observeOn(MainScheduler.instance)
            .subscribe(
                onCompleted: {
                    self.currentPage = 1
                    self.loadMovies(page: self.currentPage)
            }).addDisposableTo(bag)
    }

    private func loadMore() {
        if isSearching() {
            searchingCurrentPage += 1
            searchMovies(page: searchingCurrentPage)
        } else {
            currentPage += 1
            loadMovies(page: currentPage)
        }
    }

    private func searchMovies(page: Int = 1) {
        guard let query = searchController.searchBar.text, query.characters.count >= 2 else { return }

        refreshControl = nil

        _ = Services.searchMovies(page: page, query: query).observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { upcoming in

                    self.searchingCurrentPage = upcoming.page
                    self.searchingTotalPages = upcoming.totalPages

                    if page == 1 {
                        self.searchedMovies = upcoming.results
                    } else {
                        self.searchedMovies.append(contentsOf: upcoming.results)
                    }

                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
            },
                onError: { err in
                    self.refreshControl?.endRefreshing()
            }).addDisposableTo(bag)
    }

    @objc private func loadMovies(page: Int = 1) {
        _ = Services.loadMovies(page: page).observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { upcoming in

                    self.currentPage = upcoming.page
                    self.totalPages = upcoming.totalPages

                    if page == 1 {
                        self.movies = upcoming.results
                    } else {
                        self.movies.append(contentsOf: upcoming.results)
                    }

                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
            },
                onError: { err in
                    self.refreshControl?.endRefreshing()
            }).addDisposableTo(bag)
    }

    private func getCurrentList() -> [Movie] {
        return isSearching() ? searchedMovies : movies
    }

    private func getCurrentPage() -> Int {
        return isSearching() ? searchingCurrentPage : currentPage
    }

    private func getCurrentTotalPages() -> Int {
        return isSearching() ? searchingTotalPages : totalPages
    }

    private func isSearching() -> Bool {
        guard let query = searchController.searchBar.text, query.characters.count >= 2 else {
            return false
        }

        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCurrentList().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieListCell", for: indexPath)

        let poster = cell.viewWithTag(1) as! UIImageView
        let releaseDate = cell.viewWithTag(2) as! UILabel
        let title = cell.viewWithTag(3) as! UILabel
        let genres = cell.viewWithTag(4) as! UILabel

        let movie = getCurrentList()[indexPath.row]

        if let posterUrl = movie.posterUrl {
            poster.sd_setImage(with: posterUrl)
        } else {
            poster.image = nil
        }

        releaseDate.text = Utils.formatDate(movie.releaseDate, dateStyle: .short)
        title.text = movie.title
        genres.text = Utils.getGenres(genreIds: movie.genreIds).joined(separator: ", ")

        if indexPath.row == (getCurrentList().count - 1) && getCurrentPage() < getCurrentTotalPages() {
            loadMore()
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MovieDetailsSegue", sender: getCurrentList()[indexPath.row])
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieDetail = segue.destination as! MovieDetailTableViewController
        let movie = sender as! Movie

        movieDetail.movie = movie
    }

    // MARK - Search

    public func updateSearchResults(for searchController: UISearchController) {
        searchMovies()
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.contentOffset = CGPoint(x: 0, y: tableView.tableHeaderView?.frame.height ?? 0)
        tableView.reloadData()
    }
}
