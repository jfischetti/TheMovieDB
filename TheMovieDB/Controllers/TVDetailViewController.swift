//
//  TVDetailViewController.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/15/21.
//

import Foundation
import UIKit
import RxSwift

class TVDetailViewController : UIViewController {

    private let disposeBag = DisposeBag()
    var networkingManager = NetworkManager()
    var viewModel: (TVDetailViewModelProtocol & FavoriteContentProtocol)?
    var contentId: Int?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var firstAiredLbl: UILabel!
    @IBOutlet weak var seasonsLbl: UILabel!
    @IBOutlet weak var episodesLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var overviewLbl: UILabel!

    static func configure(contentId: Int) -> TVDetailViewController? {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "TVDetailViewController") as? TVDetailViewController
        vc?.contentId = contentId

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TVDetailViewModel(withAPI: TheMovieDBAPI(networkingManager), dataManager: CoreDataStack())

        self.setupUI()
        self.setupBindings()

        if let id = self.contentId {
            self.viewModel?.getTVDetail(by: id)
        }
    }

    func setupUI() {
        self.titleLbl.text = ""
        self.firstAiredLbl.text = ""
        self.ratingLbl.text = ""
        self.seasonsLbl.text = ""
        self.episodesLbl.text = ""
        self.overviewLbl.text = ""
    }

    func setupBindings() {
        // setup datasource
        _ = self.viewModel?.tvDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { tvDetail in
                self.display(with: tvDetail)
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
            self.saveImage.image = emptyStar.image(with: .white)
        }

        self.saveImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        self.saveImage.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { recognizer in

            isFavorite = self.viewModel?.isFavoriteContent(content: content)
            if let isFavorite = isFavorite, isFavorite == true {
                UIView.transition(with: self.saveImage, duration: 1, options: .transitionFlipFromRight, animations: {
                    self.saveImage.image = emptyStar.image(with: .white)
                }, completion: nil)
                self.viewModel?.unFavoriteContent(content: content)
            } else {
                UIView.transition(with: self.saveImage, duration: 1, options: .transitionFlipFromRight, animations: {
                    self.saveImage.image = filledStar.image(with: .yellow)
                }, completion: nil)
                self.viewModel?.favoriteContent(content: content)
            }
        })
        .disposed(by: self.disposeBag)
        
    }

    func display(with tvDetail: TVDetail) {

        if let url = tvDetail.posterUrl(), let data = try? Data(contentsOf: url) {
            self.imageView.image = UIImage(data: data)
        } else {
            self.imageView.image = UIImage(named: "empty")
        }

        self.titleLbl.text = tvDetail.title
        self.ratingLbl.text = "Rating: \(tvDetail.voteAverage ?? 0)/10"
        self.overviewLbl.text = tvDetail.overview == nil || tvDetail.overview == "" ? "Not available." : tvDetail.overview

        if let firstAired = tvDetail.firstAired {
            self.firstAiredLbl.text = "First Aired: " + firstAired
        }
        
        self.seasonsLbl.text = "Seasons: \(tvDetail.seasons ?? 0)"
        self.episodesLbl.text = "Episodes: \(tvDetail.episodes ?? 0)"

        setupTapToSaveButton(with: tvDetail)
    }
}
