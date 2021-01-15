//
//  Content.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import Foundation

protocol ContentProtocol {
    var id: Int? { get }
    var title: String? { get }
    var overview: String? { get }
    var posterPath: String? { get }
    var voteAverage: Decimal? { get }

    func posterUrl() -> URL?
}
