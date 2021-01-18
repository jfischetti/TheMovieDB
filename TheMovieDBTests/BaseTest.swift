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

    let movieDetail = MovieDetail(id: 1,
                                          title: "movie",
                                          overview: "movie overview",
                                          posterPath: "/MoviePoster.png",
                                          voteAverage: 10.0,
                                          runtime: 30,
                                          releaseDate: "2021-01-01")

    let tvDetail = TVDetail(id: 1,
                                          title: "tv show",
                                          overview: "show overview",
                                          posterPath: "/TVPoster.png",
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
