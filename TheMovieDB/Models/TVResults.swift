//
//  TVResults.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import Foundation

struct TVResults: Decodable {
    let shows: [TV]

    enum CodingKeys: String, CodingKey {
        case shows = "results"
    }
}
