//
//  Movie+CoreDataProperties.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/23/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//


import Foundation
import CoreData


extension Movie {
    
    @nonobjc public class func movieFetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie");
    }
    
    @NSManaged public var isCompleted: Bool
    @NSManaged public var releaseYear: String?
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var rating: String?
    @NSManaged public var genre: String?
    @NSManaged public var barcode: String?

}
