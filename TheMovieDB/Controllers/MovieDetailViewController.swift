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
    var viewModel: (MovieDetailViewModelProtocol & FavoriteContentProtocol)?
    var contentID: Int?

    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var runtimeLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var overviewLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MovieDetailViewModel(withAPI: TheMovieDBAPI(networkingManager), dataManager: CoreDataStack())

        self.setupUI()
        self.setupBindings()

        if let id = self.contentID {
            self.viewModel?.getMovieDetail(by: id)
        }
    }

    func setupUI() {
        self.titleLbl.text = ""
        self.runtimeLbl.text = ""
        self.ratingLbl.text = ""
        self.releaseDateLbl.text = ""
        self.overviewLbl.text = ""
    }

    func setupBindings() {
        // setup datasource
        _ = self.viewModel?.movieDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { movieDetail in
                self.display(with: movieDetail)
            })
            .disposed(by: disposeBag)
    }

    func setupTapToSaveButton(with content: ContentProtocol) {
        // setup tap to save
        let emptyStar = "☆"
        let filledStar = "★"

        var isFavorite = self.viewModel?.isFavoriteContent(content: content)
        if let isFavorite = isFavorite, isFavorite == true {
            self.saveImage.image = filledStar.image(with: .yellow)
        } else {
            self.saveImage.image = emptyStar.image(with: .black)
        }

        self.saveImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        self.saveImage.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { recognizer in

            isFavorite = self.viewModel?.isFavoriteContent(content: content)
            if let isFavorite = isFavorite, isFavorite == true {
                self.saveImage.image = emptyStar.image(with: .black)
                self.viewModel?.unFavoriteContent(content: content)
            } else {
                self.saveImage.image = filledStar.image(with: .yellow)
                self.viewModel?.favoriteContent(content: content)
            }
        })
        .disposed(by: self.disposeBag)
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

        if let releaseDate = movieDetail.releaseDate {
            self.releaseDateLbl.text = "Release Date: " + releaseDate
        } else {
            self.releaseDateLbl.text = ""
        }

        self.overviewLbl.text = movieDetail.overview

        setupTapToSaveButton(with: movieDetail)
    }
}
