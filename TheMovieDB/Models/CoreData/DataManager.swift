//
//  DataManager.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/15/21.
//

import Foundation

/// Data manager for storing and retrieving Movie and TV content.
protocol DataManager {

    /// Gets all stored TV and Movie content..
    func getAllContents() -> [ContentProtocol]

    /// Stores TV or Movie content, or updates it if it already exists.
    /// - Parameters:
    ///   - content: The TV or Movie content.
    ///   - isFavorite: True if this content should be marked as a "favorite", otherwise false.
    ///   - contentType: The feature category this content belongs to. Nil if is being stored only as a favorite.
    func upsertContent(content: ContentProtocol, with isFavorite: Bool?, for contentType: ContentType?)

    /// Deletes TV or Movie content.
    /// - Parameter content: The content to delete.
    func removeContent(content: ContentProtocol)

    /// Gets a specific TV or Movie content.
    /// - Parameter id: The id of the content.
    func getContent(by id: Int) -> ContentProtocol?

    /// Gets if the given content is listed as a "favorite"
    /// - Parameter content: The content to check.
    func isFavoriteContent(content: ContentProtocol) -> Bool

    /// Caches a list of TV or Movie content along with the feature category they were being viewed.
    /// - Parameters:
    ///   - contentType: The feature category the were being viewed.
    ///   - contents: The TV or Movie contents.
    func cacheFeatureCategory(contentType: ContentType, with contents: [ContentProtocol])

    /// Gets the last viewed feature category and its cached TV or Movie contents.
    func getCachedFeatureCategory() -> (ContentType?, [ContentProtocol]?)
}
