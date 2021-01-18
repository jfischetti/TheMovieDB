//
//  MovieDetailViewModelTests.swift
//  TheMovieDBTests
//
//  Created by Joseph Fischetti on 1/18/21.
//

import XCTest
import RxSwift
import RxTest

class MovieDetailViewModelTests: BaseTest {

    func testGetMovieDetail() {
        // arrange
        mockAPI.getMovieDetailsReturnValue = movieDetail
        let viewModel = MovieDetailViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectMovieDetailsToBeReturned = expectation(description: "Movie details are returned")
        viewModel.movieDetail.subscribe(onNext: { result in
            XCTAssertEqual(result.id, self.movieDetail.id)
            expectMovieDetailsToBeReturned.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getMovieDetail(by: movieDetail.id!)

        // wait for assertions
        wait(for: [expectMovieDetailsToBeReturned], timeout: 1)
    }

    func testFavoriteMovie() {
        // arrange
        let viewModel = MovieDetailViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        // act
        viewModel.favoriteContent(content: movieDetail)

        // assert
        XCTAssertEqual(mockDataManager.upsertContentWasCalled, 1)
        XCTAssertEqual(mockDataManager.upsertContentWasCalledWithFavoriteParam, true)
    }

    func testUnFavoriteMovie() {
        // arrange
        let viewModel = MovieDetailViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        // act
        viewModel.unFavoriteContent(content: movieDetail)

        // assert
        XCTAssertEqual(mockDataManager.upsertContentWasCalled, 1)
        XCTAssertEqual(mockDataManager.upsertContentWasCalledWithFavoriteParam, false)
    }
}
