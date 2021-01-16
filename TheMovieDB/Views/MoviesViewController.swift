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
    var viewModel: (MoviesViewModelProtocol & FavoriteContentProtocol)?

    var isFirstAppLaunch = true

    @IBOutlet weak var collectionView: UICollectionView!
    //var searchBar: UISearchBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MoviesViewModel(withAPI: TheMovieDBAPI(networkingManager), dataManager: CoreDataStack())

        // start monitoring for network connectivity issues
        NetworkConnectivityManager.shared.startMonitoring()

        self.setupUI()
        self.setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {

        // check for network connectivity
        if NetworkConnectivityManager.shared.isReachable {
            if isFirstAppLaunch {
                isFirstAppLaunch = false
                // display the last viewed category on first launch
                if let lastCategory = self.viewModel?.lastFeaturedCategory() {
                    displayFeatureCategory(contentType: lastCategory)
                } else {
                    // there is no last category so show the default view
                    displayFeatureCategory(contentType: .nowPlayingMovies)
                }
            } else {
                // when hitting back, make sure to reload the view to fix favorited movies
                if let title = self.navigationItem.title, let contentType = ContentType(rawValue: title) {
                    displayFeatureCategory(contentType: contentType)
                }
            }
        } else {
            // display cached data
            if let lastCategory = self.viewModel?.lastFeaturedCategory() {
                self.updateFeaturedCategoryUI(contentType: lastCategory)
                self.viewModel?.getLastFeaturedCategoryCache()
            }
        }
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let screenWidth = collectionView.bounds.size.width
        layout.itemSize = CGSize(width: screenWidth / 2, height: screenWidth / 2)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
    }

    private func setupBindings() {
        // bind collectionview datasource
        _ = viewModel?.contents.bind(to: collectionView.rx.items(cellIdentifier: "Cell", cellType: MovieCollectionViewCell.self) ) { index, content, cell in

            cell.title.text = content.title

            // check for network connectivity
            if NetworkConnectivityManager.shared.isReachable {
                // fetch poster image
                if let url = content.posterUrl(), let data = try? Data(contentsOf: url){
                    cell.imageView.image = UIImage(data: data)
                } else {
                    cell.imageView.image = UIImage(named: "outline_image_black_48pt")
                }
            } else {
                // check cache for the image
                let id = String(content.id!)
                if let image = ImageCacheManager.shared.getCachedImage(by: id) {
                    cell.imageView.image = image
                } else {
                    // otherwise use default
                    cell.imageView.image = UIImage(named: "outline_image_black_48pt")
                }
            }

            let emptyStar = "☆"
            let filledStar = "★"

            var isFavorite = self.viewModel?.isFavoriteContent(content: content)
            if let isFavorite = isFavorite, isFavorite == true {
                cell.saveImage.image = filledStar.image(with: .yellow)
            } else {
                cell.saveImage.image = emptyStar.image(with: .black)
            }

            cell.saveImage.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer()
            cell.saveImage.addGestureRecognizer(tapGesture)
            tapGesture.rx.event.bind(onNext: { recognizer in
                print("tapped star on \(cell.title.text)")

                isFavorite = self.viewModel?.isFavoriteContent(content: content )
                if let isFavorite = isFavorite, isFavorite == true {
                    cell.saveImage.image = emptyStar.image(with: .black)
                    self.viewModel?.unFavoriteContent(content: content)
                } else {
                    cell.saveImage.image = filledStar.image(with: .yellow)
                    self.viewModel?.favoriteContent(content: content)
                }
            })
            .disposed(by: self.disposeBag)
        }

        // bind selection
        collectionView.rx.modelSelected(ContentProtocol.self)
            .subscribe(onNext: { content in

                if let _ = content as? Movie {
                    if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController {
                        vc.contentID = content.id
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "TVDetailViewController") as? TVDetailViewController {
                        vc.contentID = content.id
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
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
            if self?.isFirstAppLaunch == false {
                // dont update on the initial binding
                self?.displayFeatureCategory(contentType: contentType!)
            }
        })
        .disposed(by: disposeBag)
    }

    func displayFeatureCategory(contentType: ContentType) {

        updateFeaturedCategoryUI(contentType: contentType)

        switch contentType {
        case .nowPlayingMovies:
            self.viewModel?.getNowPlayingMovies()
        case .popularMovies:
            self.viewModel?.getPopularMovies()
        case .topRatedMovies:
            self.viewModel?.getTopRatedMovies()
        case .popularTV:
            self.viewModel?.getPopularTV()
        case .topRatedTv:
            self.viewModel?.getTopRatedTV()
        }
    }

    func updateFeaturedCategoryUI(contentType: ContentType) {
        // update navigation title to reflect content type
        self.navigationController?.navigationBar.topItem?.title = contentType.rawValue
        // update scope bar to reflect content type
        navigationItem.searchController?.searchBar.selectedScopeButtonIndex = ContentType.allCases.firstIndex(of: contentType)!
    }
}
