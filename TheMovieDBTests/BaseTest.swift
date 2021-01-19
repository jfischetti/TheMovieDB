//
//  BaseTest.swift
//  TheMovieDBTests
//
//  Created by Joseph Fischetti on 1/18/21.
//

import XCTest
import RxSwift

class BaseTest: XCTestCase {

    var disposeBag: DisposeBag!
    var mockAPI: MockAPI!
    var mockDataManager: MockDataManager!

    let movie = Movie(id: 1,
                      title: "movie",
                      overview: "movie overview",
                      posterPath: "/moviePoster.png",
                      voteAverage: 5.0)

    let tvShow = TV(id: 2,
                    title: "tv show",
                    overview: "tv overview",
                    posterPath: "/tvPoster.png",
                    voteAverage: 7.0)

    let movieDetail = MovieDetail(id: 3,
                                          title: "movie",
                                          overview: "movie overview",
                                          posterPath: "/moviePoster.png",
                                          voteAverage: 10.0,
                                          runtime: 30,
                                          releaseDate: "2021-01-01")

    let tvDetail = TVDetail(id: 4,
                                          title: "tv show",
                                          overview: "show overview",
                                          posterPath: "/tvPoster.png",
                                          voteAverage: 9.0,
                                          firstAired: "2021-01-01",
                                          seasons: 1,
                                          episodes: 1)

    override func setUp() {
        disposeBag = DisposeBag()
        mockAPI = MockAPI()
        mockDataManager = MockDataManager()
    }
}
