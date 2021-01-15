//
//  DataManager.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/15/21.
//

import Foundation

protocol DataManager {

    func getAllContents() -> [ContentProtocol]

    func addContent(content: ContentProtocol)

    func removeContent(content: ContentProtocol)

    func getContent(by id: Int) -> ContentProtocol?
}
