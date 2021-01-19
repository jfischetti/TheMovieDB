//
//  TVDetailViewModelTests.swift
//  TheMovieDBTests
//
//  Created by Joseph Fischetti on 1/18/21.
//

import XCTest
import RxSwift
import RxTest

class TVDetailViewModelTests: BaseTest {

    func testGetTVDetail() {
        // arrange
        mockAPI.getTVDetailsReturnValue = tvDetail
        let viewModel = TVDetailViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        let expectTVDetailsToBeReturned = expectation(description: "TV details are returned")
        viewModel.tvDetail.subscribe(onNext: { result in
            XCTAssertEqual(result.id, self.tvDetail.id)
            expectTVDetailsToBeReturned.fulfill()
        })
        .disposed(by: disposeBag)

        // act
        viewModel.getTVDetail(by: tvDetail.id!)

        // wait for assertions
        wait(for: [expectTVDetailsToBeReturned], timeout: 1)
    }

    func testFavoriteShow() {
        // arrange
        let viewModel = TVDetailViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        // act
        viewModel.favoriteContent(content: tvDetail)

        // assert
        XCTAssertEqual(mockDataManager.upsertContentWasCalled, 1)
        XCTAssertEqual(mockDataManager.upsertContentWasCalledWithFavoriteParam, true)
    }

    func testUnFavoriteShow() {
        // arrange
        let viewModel = TVDetailViewModel(withAPI: mockAPI, dataManager: mockDataManager)

        // act
        viewModel.unFavoriteContent(content: tvDetail)

        // assert
        XCTAssertEqual(mockDataManager.upsertContentWasCalled, 1)
        XCTAssertEqual(mockDataManager.upsertContentWasCalledWithFavoriteParam, false)
    }
}
