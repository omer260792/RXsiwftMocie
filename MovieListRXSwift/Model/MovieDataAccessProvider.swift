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
    public func addMovie(withMovie movie: String) {
        let newMovie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: managedObjectContext) as! Movie
        
        newMovie.releaseYear = movie
        newMovie.isCompleted = false
        
        do {
            try managedObjectContext.save()
            movieFromCoreData.value = fetchData()
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
    
}
