//
//  MovieDetailViewModel.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import RxSwift

protocol MovieDetailViewModelProtocol {

    /// Observable for views to bind to
    var movieDetail: Observable<MovieDetail> { get }

    /// Gets detailed info for Movie content and updates the movieDetail observable.
    /// - Parameter id: The id of the content.
    func getMovieDetail(by id: Int)
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol, FavoriteContentProtocol {

    var movieDetail: Observable<MovieDetail>
    private let disposeBag = DisposeBag()
    private let movieAPI: TheMovieDBAPIProtocol
    var dataManager: DataManager

    private let movieDetailSubject = PublishSubject<MovieDetail>()

    init(withAPI movieAPI: TheMovieDBAPIProtocol, dataManager: DataManager) {
        self.movieAPI = movieAPI
        self.movieDetail = movieDetailSubject.asObserver()
        self.dataManager = dataManager
    }

    func getMovieDetail(by id: Int) {
        movieAPI.getMovieDetails(by: id)
            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just(nil)
            }
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    // update observers
                    self?.movieDetailSubject.onNext(result)
                }
            }, onError: { error in
                print("Error getting Top Rated Movies: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
