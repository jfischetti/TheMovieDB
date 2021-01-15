//
//  Movie.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/13/21.
//

import Foundation

struct Movie: Decodable, ContentProtocol {

    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let voteAverage: Decimal?

    func posterUrl() -> URL? {
        let str = "\(NetworkConstants.imagesBaseURL)\(NetworkConstants.posterThumbnailSize)\(posterPath ?? "")"
        return URL(string: str)
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
