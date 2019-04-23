//
//  Movie.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/23/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation


struct ModelMovie: Decodable{
    
    let title: String
    let image: String
    let rating: Double
    let releaseYear: Double
    let genre: [String]
}


//struct Movie {
//    
//    let title: String
//    let image: String
//    let rating: Double
//    let releaseYear: Double
//    let genre: [String]
//}
