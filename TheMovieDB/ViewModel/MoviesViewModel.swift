//
//  MoviesViewModel.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import RxSwift

protocol MoviesViewModelProtocol {
    var contents: Observable<[ContentProtocol]> { get }
    func getTopRatedMovies()
}

final class MoviesViewModel: MoviesViewModelProtocol {

    var contents: Observable<[ContentProtocol]>
    private let disposeBag = DisposeBag()
    private let movieAPI: TheMovieDBAPIProtocol

    private let contentsSubject = PublishSubject<[ContentProtocol]>()

    init(withAPI movieAPI: TheMovieDBAPIProtocol) {
        self.movieAPI = movieAPI
        self.contents = contentsSubject.asObserver()
    }

    func getTopRatedMovies() {
        movieAPI.getTopRatedMovies()
            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just([])
            }
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    self?.contentsSubject.onNext(result)
                }
            }, onError: { error in
                print("Error getting Top Rated Movies: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
