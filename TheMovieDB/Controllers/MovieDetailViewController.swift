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
    var viewModel: (MovieDetailViewModelProtocol & FavoriteContentProtocol)?
    var contentId: Int?

    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var runtimeLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var overviewLbl: UILabel!

    static func configure(contentId: Int) -> MovieDetailViewController? {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController
        vc?.contentId = contentId
        vc?.viewModel = MovieDetailViewModel(withAPI: TheMovieDBAPI(NetworkManager()), dataManager: CoreDataStack())
        
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupBindings()

        if let id = self.contentId {
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

        let emptyStar = "☆"
        let filledStar = "★"

        // check if this is a favorite
        var isFavorite = self.viewModel?.isFavoriteContent(content: content)

        // update the initial image
        if let isFavorite = isFavorite, isFavorite == true {
            self.saveImage.image = filledStar.image(with: .yellow)
        } else {
            self.saveImage.image = emptyStar.image(with: .white)
        }

        // enable tap gesture
        self.saveImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        self.saveImage.addGestureRecognizer(tapGesture)

        // bind tap gesture
        tapGesture.rx.event.bind(onNext: { recognizer in

            // on tap, check if content is currently favorite content.
            isFavorite = self.viewModel?.isFavoriteContent(content: content)
            if let isFavorite = isFavorite, isFavorite == true {
                // animate star flipping
                UIView.transition(with: self.saveImage, duration: 1, options: .transitionFlipFromRight, animations: {
                    self.saveImage.image = emptyStar.image(with: .white)
                }, completion: nil)

                self.viewModel?.unFavoriteContent(content: content)
            } else {
                // animate star flipping
                UIView.transition(with: self.saveImage, duration: 1, options: .transitionFlipFromRight, animations: {
                    self.saveImage.image = filledStar.image(with: .yellow)
                }, completion: nil)
                
                self.viewModel?.favoriteContent(content: content)
            }
        })
        .disposed(by: self.disposeBag)
    }

    func display(with movieDetail: MovieDetail) {
        if let url = movieDetail.posterUrl(), let data = try? Data(contentsOf: url) {
            self.imageView.image = UIImage(data: data)
        } else {
            self.imageView.image = UIImage(named: "empty")
        }

        self.titleLbl.text = movieDetail.title
        self.runtimeLbl.text = movieDetail.runtimeString()
        self.ratingLbl.text = "Rating: \(movieDetail.voteAverage ?? 0)/10"

        if let releaseDate = movieDetail.releaseDate {
            self.releaseDateLbl.text = "Release Date: " + releaseDate
        } else {
            self.releaseDateLbl.text = ""
        }

        self.overviewLbl.text = movieDetail.overview == nil || movieDetail.overview == "" ? "Not available." : movieDetail.overview

        setupTapToSaveButton(with: movieDetail)
    }
}
