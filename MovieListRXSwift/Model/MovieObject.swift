//
//  MovieObject.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/23/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation


struct MovieObject: Codable {
    let title: String
    let image: String
    let rating: Double
    let releaseYear: Double
    let genre: [String]
}


struct MovieList: Codable {
    let MovieObjects: [MovieObject]
}

extension MovieList {
    
    static var all: Resource<MovieList> = {
        let url = URL(string: "https://api.androidhive.info/json/movies.json")!
        return Resource(url: url)
    }()
    
}


