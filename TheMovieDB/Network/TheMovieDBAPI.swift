//
//  TheMovieDBAPI.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/13/21.
//

import RxSwift

protocol TheMovieDBAPIProtocol {
    func getTopRatedMovies() -> Observable<[Movie]?>
    func getNowPlayingMovies() -> Observable<[Movie]?>
    func getPopularMovies() -> Observable<[Movie]?>
    func getPopularTV() -> Observable<[TV]?>
    func getTopRatedTV() -> Observable<[TV]?>
    func getMovieDetails(by id:Int) -> Observable<MovieDetail?>
    func searchMovies(with query: String) -> Observable<[Movie]?>
}

class TheMovieDBAPI: TheMovieDBAPIProtocol {

    private let networkingManager: NetworkingManager

    init(_ networkingManager: NetworkingManager) {
        self.networkingManager = networkingManager
    }

    func getTopRatedMovies() -> Observable<[Movie]?> {
        let urlString = "\(NetworkConstants.baseURL)\(NetworkConstants.discoverMoviesPath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlSafeString = urlString, let url = URL(string: urlSafeString) else { return Observable.error(NetworkError.invalidURL) }

        var query: [String: String] = NetworkConstants.defaultRequestParams
        query["sort_by"] = "vote_average.desc"

        let resource = Resource<MovieResults?>(url: url, parameter: query)

        return networkingManager.load(resource: resource)
            .map { results -> [Movie] in
                results!.movies
            }
            .asObservable()
            .retry(2)
    }

    func getNowPlayingMovies() -> Observable<[Movie]?> {
        let urlString = "\(NetworkConstants.baseURL)\(NetworkConstants.discoverMoviesPath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlSafeString = urlString, let url = URL(string: urlSafeString) else { return Observable.error(NetworkError.invalidURL) }

        var query: [String: String] = NetworkConstants.defaultRequestParams
        let now = Date()
        query["primary_release_date.lte"] = now.toTMDBFormat()
        query["primary_release_date.gte"] = now.adding(months: -1)?.toTMDBFormat()

        let resource = Resource<MovieResults?>(url: url, parameter: query)

        return networkingManager.load(resource: resource)
            .map { results -> [Movie] in
                results!.movies
            }
            .asObservable()
            .retry(2)
    }

    func getPopularMovies() -> Observable<[Movie]?> {
        let urlString = "\(NetworkConstants.baseURL)\(NetworkConstants.discoverMoviesPath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlSafeString = urlString, let url = URL(string: urlSafeString) else { return Observable.error(NetworkError.invalidURL) }

        var query: [String: String] = NetworkConstants.defaultRequestParams
        query["sort_by"] = "popularity.desc"

        let resource = Resource<MovieResults?>(url: url, parameter: query)

        return networkingManager.load(resource: resource)
            .map { results -> [Movie] in
                results!.movies
            }
            .asObservable()
            .retry(2)
    }

    func getPopularTV() -> Observable<[TV]?> {
        let urlString = "\(NetworkConstants.baseURL)\(NetworkConstants.discoverTVPath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlSafeString = urlString, let url = URL(string: urlSafeString) else { return Observable.error(NetworkError.invalidURL) }

        var query: [String: String] = NetworkConstants.defaultRequestParams
        query["sort_by"] = "popularity.desc"

        let resource = Resource<TVResults?>(url: url, parameter: query)

        return networkingManager.load(resource: resource)
            .map { results -> [TV] in
                results!.shows
            }
            .asObservable()
            .retry(2)
    }

    func getTopRatedTV() -> Observable<[TV]?> {
        let urlString = "\(NetworkConstants.baseURL)\(NetworkConstants.discoverTVPath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlSafeString = urlString, let url = URL(string: urlSafeString) else { return Observable.error(NetworkError.invalidURL) }

        var query: [String: String] = NetworkConstants.defaultRequestParams
        query["sort_by"] = "vote_average.desc"

        let resource = Resource<TVResults?>(url: url, parameter: query)

        return networkingManager.load(resource: resource)
            .map { results -> [TV] in
                results!.shows
            }
            .asObservable()
            .retry(2)
    }

    func getMovieDetails(by id: Int) -> Observable<MovieDetail?> {
        let urlString = "\(NetworkConstants.baseURL)\(NetworkConstants.getMovieDetailPath)\(id)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlSafeString = urlString, let url = URL(string: urlSafeString) else { return Observable.error(NetworkError.invalidURL) }

        let query: [String: String] = NetworkConstants.defaultRequestParams

        let resource = Resource<MovieDetail?>(url: url, parameter: query)

        return networkingManager.load(resource: resource)
            .map { result -> MovieDetail in
                result!
            }
            .asObservable()
            .retry(2)
    }

    func searchMovies(with query: String) -> Observable<[Movie]?> {
        let urlString = "\(NetworkConstants.baseURL)\(NetworkConstants.searchMoviesPath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlSafeString = urlString, let url = URL(string: urlSafeString) else { return Observable.error(NetworkError.invalidURL) }

        var params: [String: String] = NetworkConstants.defaultRequestParams
        params["query"] = query

        let resource = Resource<MovieResults?>(url: url, parameter: params)

        return networkingManager.load(resource: resource)
            .map { results -> [Movie] in
                results!.movies
            }
            .asObservable()
            .retry(2)
    }
}
