//
//  NetworkConstants.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/13/21.
//

import Foundation

struct NetworkConstants {
    static let defaultRequestParams = ["api_key": "cfab58dcb1782dcee7638fed41345bee", "language":"en-US"]
    static let defaultRequestHeaders = ["Content-type": "application/json; charset=utf-8"]
    static let baseURL = "https://api.themoviedb.org/3"
    static let discoverMoviesPath = "/discover/movie"
    static let discoverTVPath = "/discover/tv"
    static let getMovieDetailPath = "/movie/"
    static let getTVDetailPath = "/tv/"
    static let imagesBaseURL = "https://image.tmdb.org/t/p/"
    static let posterThumbnailSize = "w92/"
    static let posterDetailSize = "original/"//"w342/"
}
