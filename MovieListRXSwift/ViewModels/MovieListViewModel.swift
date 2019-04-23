//
//  MovieListViewModel.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/23/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

struct MovieListViewModel {
    
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
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - add new movie from Core Data
    public func addMovie(withMovie movie: String) {
        movieDataAccessProvider.addMovie(withMovie: movie)
    }
    
    // MARK: - toggle selected movie's isCompleted value
    public func toggleMovieIsCompleted(withIndex index: Int) {
        movieDataAccessProvider.toggleMovieIsCompleted(withIndex: index)
    }
    
    
    // MARK: - remove specified movie from Core Data
    public func removeMovie(withIndex index: Int) {
        movieDataAccessProvider.removeMovie(withIndex: index)
    }
    
}
