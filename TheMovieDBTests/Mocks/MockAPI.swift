//
//  MockAPI.swift
//  TheMovieDBTests
//
//  Created by Joseph Fischetti on 1/18/21.
//

import Foundation
import RxSwift

class MockAPI: TheMovieDBAPIProtocol {

    var getMovieReturnValue: [Movie]?
    var getTVReturnValue: [TV]?

    func getTopRatedMovies() -> Observable<[Movie]?> {
        return Observable.create { observer in
            observer.onNext(self.getMovieReturnValue)
            return Disposables.create()
        }
    }

    func getNowPlayingMovies() -> Observable<[Movie]?> {
        return Observable.create { observer in
            observer.onNext(self.getMovieReturnValue)
            return Disposables.create()
        }
    }

    func getPopularMovies() -> Observable<[Movie]?> {
        return Observable.create { observer in
            observer.onNext(self.getMovieReturnValue)
            return Disposables.create()
        }
    }

    func getPopularTV() -> Observable<[TV]?> {
        return Observable.create { observer in
            observer.onNext(self.getTVReturnValue)
            return Disposables.create()
        }
    }

    func getTopRatedTV() -> Observable<[TV]?> {
        return Observable.create { observer in
            observer.onNext(self.getTVReturnValue)
            return Disposables.create()
        }
    }

    var getMovieDetailsReturnValue: MovieDetail?
    func getMovieDetails(by id: Int) -> Observable<MovieDetail?> {
        return Observable.create { observer in
            observer.onNext(self.getMovieDetailsReturnValue)
            return Disposables.create()
        }
    }

    var getTVDetailsReturnValue: TVDetail?
    func getTVDetails(by id: Int) -> Observable<TVDetail?> {
        return Observable.create { observer in
            observer.onNext(self.getTVDetailsReturnValue)
            return Disposables.create()
        }
    }

    func searchMovies(with query: String) -> Observable<[Movie]?> {
        return Observable.create { observer in
            observer.onNext(self.getMovieReturnValue)
            return Disposables.create()
        }
    }


}
