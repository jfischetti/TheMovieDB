//
//  MoviesViewModelTests.swift
//  TheMovieDBTests
//
//  Created by Joseph Fischetti on 1/18/21.
//

import XCTest
import RxSwift
import RxTest

class MoviesViewModelTests: BaseTest {

    func testLastFeaturedCategory() {
        // arrange
        mockDataManager.getCachedFeatureCategoryReturnContentType = .nowPlayingMovies
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        // act
        let category = viewModel.lastFeaturedCategory()

        // assert
        XCTAssertEqual(category, .nowPlayingMovies)
    }

    func testGetLastFeaturedCategoryCacheWithContent() {
        // arrange
        mockDataManager.getCachedFeatureCategoryReturnContents = [movie]
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectCacheValue = expectation(description: "Cache is valued")
        viewModel.contents.subscribe(onNext: { result in
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.id, self.movie.id)
            expectCacheValue.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getLastFeaturedCategoryCache()

        // wait for assertions
        wait(for: [expectCacheValue], timeout: 1)
    }

    func testGetLastFeaturedCategoryCacheWithOutContent() {
        // arrange
        mockDataManager.getCachedFeatureCategoryReturnContents = nil
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectCacheValue = expectation(description: "Cache is not valued")
        viewModel.contents.subscribe(onNext: { result in
            XCTAssertEqual(result.count, 0)
            expectCacheValue.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getLastFeaturedCategoryCache()

        // wait for assertions
        wait(for: [expectCacheValue], timeout: 1)
    }

    func testGetTopRatedMovies() {
        // arrange
        mockAPI.getMovieReturnValue = [movie]
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectMovieResults = expectation(description: "Movies are returned")
        viewModel.contents.subscribe(onNext: { result in
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.id, self.movie.id)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalled, 1)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalledWithContentType, .topRatedMovies)
            expectMovieResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getTopRatedMovies()

        // wait for assertions
        wait(for: [expectMovieResults], timeout: 1)
    }

    func testGetTopRatedMoviesNoResults() {
        // arrange
        mockAPI.getMovieReturnValue = []
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectMovieResults = expectation(description: "No movies are returned")
        expectMovieResults.isInverted = true
        viewModel.contents.subscribe(onNext: { result in
            expectMovieResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getTopRatedMovies()

        // wait for assertions
        wait(for: [expectMovieResults], timeout: 1)
    }

    func testGetNowPlayingMovies() {
        // arrange
        mockAPI.getMovieReturnValue = [movie]
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectMovieResults = expectation(description: "Movies are returned")
        viewModel.contents.subscribe(onNext: { result in
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.id, self.movie.id)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalled, 1)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalledWithContentType, .nowPlayingMovies)
            expectMovieResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getNowPlayingMovies()

        // wait for assertions
        wait(for: [expectMovieResults], timeout: 1)
    }

    func testGetNowPlayingMoviesNoResults() {
        // arrange
        mockAPI.getMovieReturnValue = []
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectMovieResults = expectation(description: "No movies are returned")
        expectMovieResults.isInverted = true
        viewModel.contents.subscribe(onNext: { result in
            expectMovieResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getNowPlayingMovies()

        // wait for assertions
        wait(for: [expectMovieResults], timeout: 1)
    }

    func testGetPopularMovies() {
        // arrange
        mockAPI.getMovieReturnValue = [movie]
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectMovieResults = expectation(description: "Movies are returned")
        viewModel.contents.subscribe(onNext: { result in
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.id, self.movie.id)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalled, 1)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalledWithContentType, .popularMovies)
            expectMovieResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getPopularMovies()

        // wait for assertions
        wait(for: [expectMovieResults], timeout: 1)
    }

    func testGetPopularMoviesNoResults() {
        // arrange
        mockAPI.getMovieReturnValue = []
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectMovieResults = expectation(description: "No movies are returned")
        expectMovieResults.isInverted = true
        viewModel.contents.subscribe(onNext: { result in
            expectMovieResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getPopularMovies()

        // wait for assertions
        wait(for: [expectMovieResults], timeout: 1)
    }

    func testGetPopularTV() {
        // arrange
        mockAPI.getTVReturnValue = [tvShow]
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectTVShowResults = expectation(description: "TV shows are returned")
        viewModel.contents.subscribe(onNext: { result in
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.id, self.tvShow.id)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalled, 1)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalledWithContentType, .popularTV)
            expectTVShowResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getPopularTV()

        // wait for assertions
        wait(for: [expectTVShowResults], timeout: 1)
    }

    func testGetPopularTVNoResults() {
        // arrange
        mockAPI.getTVReturnValue = []
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectTVShowResults = expectation(description: "No TV shows are returned")
        expectTVShowResults.isInverted = true
        viewModel.contents.subscribe(onNext: { result in
            expectTVShowResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getPopularTV()

        // wait for assertions
        wait(for: [expectTVShowResults], timeout: 1)
    }

    func testGetTopRatedTV() {
        // arrange
        mockAPI.getTVReturnValue = [tvShow]
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectTVShowResults = expectation(description: "TV shows are returned")
        viewModel.contents.subscribe(onNext: { result in
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.id, self.tvShow.id)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalled, 1)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalledWithContentType, .topRatedTv)
            expectTVShowResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getTopRatedTV()

        // wait for assertions
        wait(for: [expectTVShowResults], timeout: 1)
    }

    func testGetTopRatedTVNoResults() {
        // arrange
        mockAPI.getTVReturnValue = []
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectTVShowResults = expectation(description: "No TV shows are returned")
        expectTVShowResults.isInverted = true
        viewModel.contents.subscribe(onNext: { result in
            expectTVShowResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getTopRatedTV()

        // wait for assertions
        wait(for: [expectTVShowResults], timeout: 1)
    }

    func testSearchMovies() {
        // arrange
        mockAPI.getMovieReturnValue = [movie]
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectMovieResults = expectation(description: "Movies are returned")
        viewModel.contents.subscribe(onNext: { result in
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.id, self.movie.id)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalled, 0)
            expectMovieResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.searchMovies(with: movie.title!)

        // wait for assertions
        wait(for: [expectMovieResults], timeout: 1)
    }

    func testSearchMoviesNoResults() {
        // arrange
        mockAPI.getMovieReturnValue = []
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectMovieResults = expectation(description: "An empty list of movies are returned")
        viewModel.contents.subscribe(onNext: { result in
            XCTAssertEqual(result.count, 0)
            XCTAssertEqual(self.mockDataManager.cacheFeatureCategoryWasCalled, 0)
            expectMovieResults.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.searchMovies(with: "A movie that doesn't exist")

        // wait for assertions
        wait(for: [expectMovieResults], timeout: 1)
    }

    func testFavorite() {
        // arrange
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        // act
        viewModel.favoriteContent(content: movie)

        // assert
        XCTAssertEqual(mockDataManager.upsertContentWasCalled, 1)
        XCTAssertEqual(mockDataManager.upsertContentWasCalledWithFavoriteParam, true)
    }

    func testUnFavorite() {
        // arrange
        let viewModel = MoviesViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        // act
        viewModel.unFavoriteContent(content: movie)

        // assert
        XCTAssertEqual(mockDataManager.upsertContentWasCalled, 1)
        XCTAssertEqual(mockDataManager.upsertContentWasCalledWithFavoriteParam, false)
    }
}
