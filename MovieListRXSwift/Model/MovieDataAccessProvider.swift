//
//  MovieDataAccessProvider.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/23/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

//MovieDataAccessProvider



import Foundation
import CoreData
import RxSwift
import UIKit
import SDWebImage

class MovieDataAccessProvider {
    
    private var movieFromCoreData = Variable<[Movie]>([])
    private var managedObjectContext : NSManagedObjectContext
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        movieFromCoreData.value = [Movie]()
        managedObjectContext = delegate.persistentContainer.viewContext
        
        movieFromCoreData.value = fetchData()
    }
    
    // MARK: - fetching Todos from Core Data and update observable todos
    private func fetchData() -> [Movie] {
        let todoFetchRequest = Movie.movieFetchRequest()
        todoFetchRequest.returnsObjectsAsFaults = false
        
        do {
            return try managedObjectContext.fetch(todoFetchRequest)
        } catch {
            return []
        }
        
    }
    
    // MARK: - return observable movie
    public func fetchObservableData() -> Observable<[Movie]> {
        movieFromCoreData.value = fetchData()
        return movieFromCoreData.asObservable()
    }
    
    // MARK: - add new movie from Core Data
    public func addMovie(withMovie releaseYear: Double, title: String, image: String, rating: Double, genre: [String], barcode: String) {
        
        let newMovie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: managedObjectContext) as! Movie
        
        let string = trimString(genre: genre.description)
        
        newMovie.isCompleted = false
        newMovie.releaseYear = String(format: "%.2f", releaseYear)
        newMovie.title = title
        newMovie.image = image
        newMovie.rating =  String(format: "%.2f", rating)
        newMovie.genre =  string
        newMovie.barcode = barcode
  
        do {
            try managedObjectContext.save()
            movieFromCoreData.value = fetchData()
            print("saving data")
        } catch {
            fatalError("error saving data")
        }
    }
    
    // MARK: - toggle selected movie's isCompleted value
    public func toggleMovieIsCompleted(withIndex index: Int) {
        movieFromCoreData.value[index].isCompleted = !movieFromCoreData.value[index].isCompleted
        
        do {
            try managedObjectContext.save()
            movieFromCoreData.value = fetchData()
        } catch {
            fatalError("error change data")
        }
        
    }
    
    // MARK: - remove specified movie from Core Data
    public func removeMovie(withIndex index: Int) {
        managedObjectContext.delete(movieFromCoreData.value[index])
        
        do {
            try managedObjectContext.save()
            movieFromCoreData.value = fetchData()
        } catch {
            fatalError("error delete data")
        }
    }
    
    // MARK: - Get array string and trim string to Core Data

    func trimString(genre: String) -> String {
        let str = genre
        var res = str.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
        res = res.trim("]")
        let _ : [Character]
        var string : [String] = []
        var endstring : String = ""
        string = res.components(separatedBy: "\"")
        for n in 0...string.count-1{
            endstring = endstring + string[n]
        }
        return endstring
    }
}


extension String {
    
    func trim(_ string: String) -> String {
        var set = Set<Character>()
        for c in string {
            set.insert(Character(String(c)))
        }
        return trim(set)
    }
    
    func trim(_ characters: Set<Character>) -> String {
        if let index = self.index(where: {!characters.contains($0)}) {
            return String(self[index..<self.endIndex])
        } else {
            return ""
        }
    }
    
}
