//
//  MovieDetailViewModel.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import RxSwift

protocol MovieDetailViewModelProtocol {
    var movieDetail: Observable<MovieDetail> { get }
    func getMovieDetail(by id: Int)
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {

    var movieDetail: Observable<MovieDetail>
    private let disposeBag = DisposeBag()
    private let movieAPI: TheMovieDBAPIProtocol

    private let movieDetailSubject = PublishSubject<MovieDetail>()

    init(withAPI movieAPI: TheMovieDBAPIProtocol) {
        self.movieAPI = movieAPI
        self.movieDetail = movieDetailSubject.asObserver()
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
                    self?.movieDetailSubject.onNext(result)
                }
            }, onError: { error in
                print("Error getting Top Rated Movies: \(error)")
            })
            .disposed(by: disposeBag)
    }
}