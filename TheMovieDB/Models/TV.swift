//
//  TV.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/13/21.
//

import Foundation

struct TV: Decodable, ContentProtocol {

    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let voteAverage: Decimal?

    func posterUrl() -> URL? {
        return URL(string: "\(NetworkConstants.imagesBaseURL)\(NetworkConstants.posterThumbnailSize)\(posterPath ?? "")")
    }

    enum CodingKeys: String, CodingKey {
        case id, overview
        case title = "name"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
