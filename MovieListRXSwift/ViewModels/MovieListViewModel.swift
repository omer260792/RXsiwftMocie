//
//  MovieListViewModel.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/23/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

struct MovieListViewModel {
    let relay = BehaviorRelay(value: [Movie].self)

    private var movies = Variable<[Movie]>([])
    private var movieDataAccessProvider = MovieDataAccessProvider()
    private var disposeBag = DisposeBag()
    
    init() {
        fetchMoviesAndUpdateObservableMovies()
    }
    
    public func getMovies() -> Variable<[Movie]> {
        return movies
    }
    
    // MARK: - fetching Movies from Core Data and update observable Movies
    private func fetchMoviesAndUpdateObservableMovies() {
        movieDataAccessProvider.fetchObservableData()
            .map({ $0 })
            .subscribe(onNext : { (movies) in
                self.movies.value = movies
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - add new movie from Core Data
    public func addMovie(withMovie releaseYear: Double, title: String, image: String, rating: Double, genre: [String], barcode: String) {
        movieDataAccessProvider.addMovie(withMovie: releaseYear, title: title, image: image, rating: rating, genre: genre, barcode: barcode)
        
    }
    
    // MARK: - toggle selected movie's isCompleted value
    public func toggleMovieIsCompleted(withIndex index: Int) {
        movieDataAccessProvider.toggleMovieIsCompleted(withIndex: index)
    }
    
    
    // MARK: - remove specified movie from Core Data
    public func removeMovie(withIndex index: Int) {
        movieDataAccessProvider.removeMovie(withIndex: index)
    }
    
    
    public func removeAllMovie(withIndex index: Int) {
        movieDataAccessProvider.removeMovie(withIndex: index)
    }
}
