//
//  SaveContentProtocol.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/15/21.
//

import Foundation

protocol FavoriteContentProtocol {
    var dataManager: DataManager { get }

    func favoriteContent(content: ContentProtocol)
    func isFavoriteContent(content: ContentProtocol) -> Bool
    func unFavoriteContent(content: ContentProtocol)
}

extension FavoriteContentProtocol {
    func favoriteContent(content: ContentProtocol) {
        // update favorite
        self.dataManager.upsertContent(content: content, with: true, for: nil)
    }

    func isFavoriteContent(content: ContentProtocol) -> Bool {
        return self.dataManager.isFavoriteContent(content: content)
    }

    func unFavoriteContent(content: ContentProtocol) {
        self.dataManager.upsertContent(content: content, with: false, for: nil)
    }
}
