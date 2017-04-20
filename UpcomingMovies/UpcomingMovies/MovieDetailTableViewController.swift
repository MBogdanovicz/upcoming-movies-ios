//
//  MovieDetailTableViewController.swift
//  UpcomingMovies
//
//  Created by Marcelo Bogdanovicz on 19/04/17.
//  Copyright © 2017 Capivara EC. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class MovieDetailTableViewController: UITableViewController {

    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblGenresTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblOverview: UILabel!

    var movie: Movie!
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setValues()
        loadMovieDetails()
    }

    private func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.reloadData()
    }

    private func setValues() {
        if let url = movie.posterUrl {
            ivPoster.sd_setImage(with: url)
        } else {
            ivPoster.image = nil
        }

        lblTitle.text = movie.title
        lblReleaseDate.text = Utils.formatDate(movie.releaseDate)
        lblGenresTitle.text = NSLocalizedString("genres", comment: "")

        if movie.genres != nil {
            lblGenres.text = Utils.getGenres(genres: movie.genres).joined(separator: ", ")
        }

        lblOverview.text = movie.overview
    }

    private func loadMovieDetails() {
        _ = Services.loadMovieDetails(movie.id).observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { movie in
                    self.movie = movie
                    self.setValues()

            }).addDisposableTo(bag)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
