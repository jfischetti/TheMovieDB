//
//  MoviesViewController.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class MoviesViewController : UIViewController, UICollectionViewDelegateFlowLayout {

    private let disposeBag = DisposeBag()
    var networkingManager = NetworkManager()
    var viewModel: MoviesViewModelProtocol?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MoviesViewModel(withAPI: TheMovieDBAPI(networkingManager))
        self.setupBindings()

        self.viewModel?.getTopRatedMovies()
    }

    private func setupBindings() {
        // bind datasource
        _ = viewModel?.contents.bind(to: collectionView.rx.items(cellIdentifier: "Cell", cellType: MovieCollectionViewCell.self) ) { index, content, cell in

            cell.title.text = content.title
            if let url = content.posterUrl(), let data = try? Data(contentsOf: url){
                cell.imageView.image = UIImage(data: data)
            } else {
                cell.imageView.image = UIImage(named: "outline_image_black_48pt")
            }
        }

        // bind selection
        collectionView.rx.modelSelected(ContentProtocol.self)
            .subscribe(onNext: { content in
                var type = "tv show"

                if let _ = content as? Movie {
                    type = "movie"
                }

                print("selected \(type): \(content.title ?? "")")
                if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController {
                    vc.contentID = content.id
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)

        // set layout for collection
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let screenWidth = collectionView.bounds.size.width
        layout.itemSize = CGSize(width: screenWidth / 3, height: screenWidth / 3)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
    }
}
