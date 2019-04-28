//
//  ViewController.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/23/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import Foundation


class ViewController: UIViewController{
    
    var movieListViewModel = MovieListViewModel()
    var disposeBag = DisposeBag()
    private var Movies = [MovieObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movie List"

        getMoviesFromRestAPI()
    }

    // MARK: - checking if core data exist and not empty

    func coreDataExist() -> Bool {
        var bool: Bool = false
        let movieList = movieListViewModel.getMovies().asObservable()
        movieList.subscribe{ element in
            if let allMovieItemCoreData = element.element?.count {
                if allMovieItemCoreData > 0{
                    bool = true
                }else{
                    bool = false
                }
            }
        }.disposed(by: disposeBag)
        return bool
    }
    
    // MARK: - Get api url from server and save it in core data
    
    func getMoviesFromRestAPI() {
        URLRequest.load(resource: MovieList.all)
            .subscribe(onNext: { result in
                if result.first != nil {
                    let coreDataExist = self.coreDataExist()
                        if (!coreDataExist) {
                            for movie in result{
                                let code = ""
                                DispatchQueue.main.async {
                                    self.movieListViewModel.addMovie(withMovie: movie.releaseYear, title: movie.title, image: movie.image, rating: movie.rating, genre: movie.genre , barcode: code)
                                }
                            }
                        }
                    }
        }).disposed(by: disposeBag)
            
    }
    
    
}

