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

class MoviesViewController : UIViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    private let disposeBag = DisposeBag()
    var networkingManager = NetworkManager()
    var viewModel: MoviesViewModelProtocol?

    @IBOutlet weak var collectionView: UICollectionView!
    var searchBar: UISearchBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MoviesViewModel(withAPI: TheMovieDBAPI(networkingManager))

        self.setupUI()
        self.setupBindings()
    }

    private func setupUI() {
        // set search bar
        /*
        self.searchBar = UISearchBar()
        self.searchBar?.delegate = self
        self.searchBar?.placeholder = "Search movies"
        self.searchBar?.showsCancelButton = false
        self.navigationItem.titleView = searchBar
         */
        let search = UISearchController(searchResultsController: nil)

        //search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search movies"
        //search.searchBar.showsScopeBar = true
        search.searchBar.scopeButtonTitles = ContentType.allCases.map { $0.rawValue }
        let font = UIFont.systemFont(ofSize: 8)
        search.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        navigationItem.searchController = search

        // set layout for collection
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let screenWidth = collectionView.bounds.size.width
        layout.itemSize = CGSize(width: screenWidth / 3, height: screenWidth / 3)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
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

        // bind search bar text inputs
        navigationItem.searchController?.searchBar.rx.text.subscribe(onNext: { (query) in
            print("Searching: \(query ?? "nil")")
            if let query = query, query.count > 0 {
                self.navigationController?.navigationBar.topItem?.title = ""
                self.viewModel?.searchMovies(with: query)
            } else {
                // display last feature category
                //self.viewModel?.getTopRatedMovies()
            }
        })
        .disposed(by: disposeBag)

        // bind search bar's scope bar selection
        navigationItem.searchController?.searchBar.rx.selectedScopeButtonIndex.subscribe(onNext: { [weak self] index in
            let contentType = ContentType(rawValue: (self?.navigationItem.searchController?.searchBar.scopeButtonTitles![index])!)

            self?.navigationController?.navigationBar.topItem?.title = contentType?.rawValue

            switch contentType {
            case .nowPlayingMovies:
                self?.viewModel?.getNowPlayingMovies()
            case .popularMovies:
                self?.viewModel?.getPopularMovies()
            case .topRatedMovies:
                self?.viewModel?.getTopRatedMovies()
            case .popularTV:
                self?.viewModel?.getPopularTV()
            case .topRatedTv:
                self?.viewModel?.getTopRatedTV()
            case .none:
                break
            }
        })
        .disposed(by: disposeBag)
    }
}
