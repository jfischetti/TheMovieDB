//
//  MoviesViewModel.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import RxSwift

protocol MoviesViewModelProtocol {

    /// Observable for views  to bind to.
    var contents: Observable<[ContentProtocol]> { get }

    /// Gets the last featured category of content that was displayed.
    func lastFeaturedCategory() -> ContentType?

    /// Gets the cached content for the last featured category and updates the contents observable.
    func getLastFeaturedCategoryCache()

    /// Gets Top Rated Movie content and updates the content observable.
    func getTopRatedMovies()

    /// Gets Now Playing Movie content and updates the content observable.
    func getNowPlayingMovies()

    /// Gets Popular Movie content and updates the content observable.
    func getPopularMovies()

    /// Gets Popular TV content and updates the content observable.
    func getPopularTV()

    /// Gets Top Rated TV content and updates the content observable.
    func getTopRatedTV()

    /// Searches for Movies with the given query and then updates the content observable.
    /// - Parameter query: A search parameter
    func searchMovies(with query: String)
}

final class MoviesViewModel: MoviesViewModelProtocol, FavoriteContentProtocol {

    var contents: Observable<[ContentProtocol]>
    private let disposeBag = DisposeBag()
    private let movieAPI: TheMovieDBAPIProtocol
    var dataManager: DataManager

    private let contentsSubject = PublishSubject<[ContentProtocol]>()

    init(withAPI movieAPI: TheMovieDBAPIProtocol, dataManager: DataManager) {
        self.movieAPI = movieAPI
        self.contents = contentsSubject.asObserver()
        self.dataManager = dataManager
    }

    func lastFeaturedCategory() -> ContentType? {
        let cachedCategory = self.dataManager.getCachedFeatureCategory()

        // Only return the ContentType enum.
        return cachedCategory.0
    }

    func getLastFeaturedCategoryCache() {
        let cachedCategory = self.dataManager.getCachedFeatureCategory()

        // only return the list of cached Contents.
        let cachedContents = cachedCategory.1 ?? [ContentProtocol]()
        // update the observers
        self.contentsSubject.onNext(cachedContents)
    }

    func getTopRatedMovies() {

        movieAPI.getTopRatedMovies()
            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just([])
            }
            .subscribe(onNext: { [weak self] result in
                if let result = result, result.count > 0 {
                    // cache the content
                    self?.dataManager.cacheFeatureCategory(contentType: .topRatedMovies, with: result)
                    // update observers
                    self?.contentsSubject.onNext(result)
                }
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

    func getNowPlayingMovies() {

        movieAPI.getNowPlayingMovies()
            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just([])
            }
            .subscribe(onNext: { [weak self] result in
                if let result = result, result.count > 0 {
                    // cache the content
                    self?.dataManager.cacheFeatureCategory(contentType: .nowPlayingMovies, with: result)
                    // update observers
                    self?.contentsSubject.onNext(result)
                }
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

    func getPopularMovies() {

        movieAPI.getPopularMovies()
            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just([])
            }
            .subscribe(onNext: { [weak self] result in
                if let result = result, result.count > 0 {
                    // cache the content
                    self?.dataManager.cacheFeatureCategory(contentType: .popularMovies, with: result)
                    // update observers
                    self?.contentsSubject.onNext(result)
                }
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

    func getPopularTV() {

        movieAPI.getPopularTV()
            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just([])
            }
            .subscribe(onNext: { [weak self] result in
                if let result = result, result.count > 0 {
                    // cache the content
                    self?.dataManager.cacheFeatureCategory(contentType: .popularTV, with: result)
                    // update observers
                    self?.contentsSubject.onNext(result)
                }
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

    func getTopRatedTV() {

        movieAPI.getTopRatedTV()
            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just([])
            }
            .subscribe(onNext: { [weak self] result in
                if let result = result, result.count > 0 {
                    // cache the content
                    self?.dataManager.cacheFeatureCategory(contentType: .topRatedTv, with: result)
                    // update observers
                    self?.contentsSubject.onNext(result)
                }
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

    func searchMovies(with query: String) {
        movieAPI.searchMovies(with: query)
            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just([])
            }
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    // update observers
                    self?.contentsSubject.onNext(result)
                }
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
