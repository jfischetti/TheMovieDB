//
//  MockDataManager.swift
//  TheMovieDBTests
//
//  Created by Joseph Fischetti on 1/18/21.
//

import Foundation

class MockDataManager: DataManager {

    // default init
    init() { }

    var getAllContentsReturnValue: [ContentProtocol]?
    var getAllContentsWasCalled: Int = 0
    func getAllContents() -> [ContentProtocol] {
        getAllContentsWasCalled += 1
        return getAllContentsReturnValue ?? [ContentProtocol]()
    }

    var upsertContentWasCalled: Int = 0
    var upsertContentWasCalledWithFavoriteParam: Bool?
    func upsertContent(content: ContentProtocol, with isFavorite: Bool?, for contentType: ContentType?) {
        upsertContentWasCalled += 1
        upsertContentWasCalledWithFavoriteParam = isFavorite
    }

    var removeContentWasCalled: Int = 0
    func removeContent(content: ContentProtocol) {
        removeContentWasCalled += 1
    }

    var getContentWasCalled: Int = 0
    var getContentReturnValue: ContentProtocol?
    func getContent(by id: Int) -> ContentProtocol? {
        getContentWasCalled += 1
        return getContentReturnValue
    }

    var isFavoriteContentWasCalled: Int = 0
    var isFavoriteContentReturnValue: Bool?
    func isFavoriteContent(content: ContentProtocol) -> Bool {
        isFavoriteContentWasCalled += 1
        return isFavoriteContentReturnValue ?? false
    }

    var cacheFeatureCategoryWasCalled: Int = 0
    var cacheFeatureCategoryWasCalledWithContentType: ContentType?
    func cacheFeatureCategory(contentType: ContentType, with contents: [ContentProtocol]) {
        cacheFeatureCategoryWasCalled += 1
        cacheFeatureCategoryWasCalledWithContentType = contentType
    }

    var getCachedFeatureCategoryWasCalled: Int = 0
    var getCachedFeatureCategoryReturnContentType: ContentType?
    var getCachedFeatureCategoryReturnContents: [ContentProtocol]?
    func getCachedFeatureCategory() -> (ContentType?, [ContentProtocol]?) {
        getCachedFeatureCategoryWasCalled += 1
        return (getCachedFeatureCategoryReturnContentType, getCachedFeatureCategoryReturnContents)
    }


}
