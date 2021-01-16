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
    func getNowPlayingMovies()
    func getPopularMovies()
    func getPopularTV()
    func getTopRatedTV()
    func searchMovies(with query: String)
}

final class MoviesViewModel: MoviesViewModelProtocol, SaveContentProtocol {

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
                if let result = result {
                    self?.contentsSubject.onNext(result)
                }
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

    func getPopularMovies() {
        movieAPI.getPopularMovies()            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just([])
            }
            .subscribe(onNext: { [weak self] result in
                if let result = result {
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
                if let result = result {
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
                if let result = result {
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
                    self?.contentsSubject.onNext(result)
                }
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
