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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMoviesFromRestAPI()
      //  coreDataExist()


    }

    
    func coreDataExist() -> Bool {
        
        let movieList = movieListViewModel.getMovies().asObservable()
        
        movieList.subscribe{ element in
            print(element.element?.count)
            
            if let allMovieItemCoreData = element.element?.count {
                if allMovieItemCoreData > 0{
                    for n in 0...allMovieItemCoreData {
                        self.movieListViewModel.removeMovie(withIndex: n)
                    }
                }
               
            }
            
           
        }.disposed(by: disposeBag)
        
       
        return true
    }

    func getMoviesFromRestAPI() {

        let urlString = "https://api.androidhive.info/json/movies.json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }

            //Implement JSON decoding and parsing
            do {

                //Decode retrived data with JSONDecoder and assing type of Article object
                let moviesData = try JSONDecoder().decode([MovieObject].self, from: data)
                
                if moviesData.first != nil {
                    
                for movie in moviesData{
                    let code = ""
                    DispatchQueue.main.async {
                       self.movieListViewModel.addMovie(withMovie: movie.releaseYear, title: movie.title, image: movie.image, rating: movie.rating, genre: movie.genre , barcode: code)
                        }
                    }
                    

                }
                
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
}

