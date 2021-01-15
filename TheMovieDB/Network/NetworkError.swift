//
//  NetworkError.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/13/21.
//

import Foundation

enum NetworkError: Error {
    case unauthorized
    case unknown
    case invalidURL
}
