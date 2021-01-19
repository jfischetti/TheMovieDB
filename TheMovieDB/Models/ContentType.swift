//
//  ContentType.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/15/21.
//

import Foundation

enum ContentType: String, CaseIterable {
    case nowPlayingMovies = "Now Playing"
    case popularMovies = "Popular Movies"
    case topRatedMovies = "Top Movies"
    case popularTV = "Popular TV"
    case topRatedTv = "Top TV"
}
