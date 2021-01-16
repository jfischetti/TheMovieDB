//
//  DataManager.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/15/21.
//

import Foundation

protocol DataManager {

    func getAllContents() -> [ContentProtocol]

    func upsertContent(content: ContentProtocol, with isFavorite: Bool?, for contentType: ContentType?)

    func removeContent(content: ContentProtocol)

    func getContent(by id: Int) -> ContentProtocol?

    func isFavoriteContent(content: ContentProtocol) -> Bool

    func cacheFeatureCategory(contentType: ContentType, with contents: [ContentProtocol])

    func getCachedFeatureCategory() -> (ContentType?, [ContentProtocol]?)
}
