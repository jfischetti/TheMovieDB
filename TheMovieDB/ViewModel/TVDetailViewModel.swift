//
//  TVDetailViewModel.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/15/21.
//

import RxSwift

protocol TVDetailViewModelProtocol {
    var tvDetail: Observable<TVDetail> { get }
    func getTVDetail(by id: Int)
}

final class TVDetailViewModel: TVDetailViewModelProtocol, SaveContentProtocol {

    var tvDetail: Observable<TVDetail>
    private let disposeBag = DisposeBag()
    private let movieAPI: TheMovieDBAPIProtocol
    var dataManager: DataManager

    private let tvDetailSubject = PublishSubject<TVDetail>()

    init(withAPI movieAPI: TheMovieDBAPIProtocol, dataManager: DataManager) {
        self.movieAPI = movieAPI
        self.tvDetail = tvDetailSubject.asObserver()
        self.dataManager = dataManager
    }

    func getTVDetail(by id: Int) {
        movieAPI.getTVDetails(by: id)
            .retry(3)
            .catch {
                print($0.localizedDescription)
                return Observable.just(nil)
            }
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    self?.tvDetailSubject.onNext(result)
                }
            }, onError: { error in
                print("Error getting Top Rated Movies: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
