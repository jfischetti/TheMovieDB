//
//  TVDetail.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/13/21.
//

import Foundation
struct TVDetail: Decodable, ContentProtocol {

    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let voteAverage: Decimal?
    let firstAired: String?
    let seasons: Int?
    let episodes: Int?

    func posterUrl() -> URL? {
        return URL(string: "\(NetworkConstants.imagesBaseURL)\(NetworkConstants.posterDetailSize)\(posterPath ?? "")")
    }

    enum CodingKeys: String, CodingKey {
        case id, overview
        case title = "name"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case firstAired = "first_air_date"
        case seasons = "number_of_seasons"
        case episodes = "number_of_episodes"
    }
}
