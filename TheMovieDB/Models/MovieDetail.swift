//
//  MovieDetail.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/13/21.
//

import Foundation

struct MovieDetail: Decodable, ContentProtocol {

    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let voteAverage: Decimal?
    let runtime: Int?
    let releaseDate: String?

    func posterUrl() -> URL? {
        return URL(string: "\(NetworkConstants.imagesBaseURL)\(NetworkConstants.posterDetailSize)\(posterPath ?? "")")
    }

    func runtimeString() -> String {
        if let runtime = runtime {
            let minutes = runtime % 60
            let hours = runtime / 60

            if hours > 0 {
                return "\(hours)h \(minutes)min"
            } else {
                return "\(minutes)min"
            }
        } else {
            return "0 min"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}
