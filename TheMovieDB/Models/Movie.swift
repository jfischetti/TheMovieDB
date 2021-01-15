//
//  Movie.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/13/21.
//

import Foundation

struct Movie: Decodable, ContentProtocol {

    var id: Int?
    var title: String?
    var overview: String?
    var posterPath: String?
    var voteAverage: Decimal?
/*
    init(id: Int?, title: String?, overview: String?, posterPath: String?, voteAverage: Decimal?) {
        id = id
        title = title
        overview = overview
        posterPath = posterPath
        voteAverage = voteAverage
    }
*/
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
