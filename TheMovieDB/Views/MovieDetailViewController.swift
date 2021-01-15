//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import Foundation
import UIKit
import RxSwift

class MovieDetailViewController : UIViewController {

    private let disposeBag = DisposeBag()
    var networkingManager = NetworkManager()
    var viewModel: MovieDetailViewModelProtocol?
    var contentID: Int?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var runtimeLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var popularityLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var overviewLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MovieDetailViewModel(withAPI: TheMovieDBAPI(networkingManager))
        self.setupBindings()

        if let id = self.contentID {
            self.viewModel?.getMovieDetail(by: id)
        }
    }

    func setupBindings() {
        _ = self.viewModel?.movieDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { movieDetail in
                self.display(with: movieDetail)
            })
            .disposed(by: disposeBag)
    }

    func display(with movieDetail: MovieDetail) {
        if let url = movieDetail.posterUrl(), let data = try? Data(contentsOf: url) {
            self.imageView.image = UIImage(data: data)
        } else {
            self.imageView.image = UIImage(named: "outline_image_black_48pt")
        }

        self.titleLbl.text = movieDetail.title
        self.runtimeLbl.text = movieDetail.runtimeString()
        self.ratingLbl.text = "Rating: \(movieDetail.voteAverage ?? 0)"
        self.popularityLbl.text = "Popularity: \(movieDetail.popularity ?? 0)/10"

        if let releaseDate = movieDetail.releaseDate {
            self.releaseDateLbl.text = "Release Date: " + releaseDate
        } else {
            self.releaseDateLbl.text = ""
        }

        self.overviewLbl.text = movieDetail.overview
    }
}
