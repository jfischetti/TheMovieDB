//
//  SaveContentProtocol.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/15/21.
//

import Foundation

protocol SaveContentProtocol {
    var dataManager: DataManager { get }

    func saveContent(content: ContentProtocol)
    func isSavedContent(with id: Int) -> Bool
    func deleteContent(content: ContentProtocol)
}

extension SaveContentProtocol {
    func saveContent(content: ContentProtocol) {
        self.dataManager.addContent(content: content)
    }

    func isSavedContent(with id: Int) -> Bool {
        return self.dataManager.getContent(by: id) != nil
    }

    func deleteContent(content: ContentProtocol) {
        self.dataManager.removeContent(content: content)
    }
}
