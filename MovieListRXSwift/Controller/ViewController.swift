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

    var movieArray : [ModelMovie] = []
    var moviesCoreData : [NSManagedObject] = []
    
    private let movieSubject = PublishSubject<MovieList>()
    var movieSubjectObservable: Observable<MovieList> {
        return movieSubject.asObservable()
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveRX()
     //  getMoviesFromRestAPI()
      //  coreDataExist()
        
        
   
    }
    
    func coreDataExist() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        do {
            moviesCoreData = try managedContext.fetch(fetchRequest)
            
            if (moviesCoreData.isEmpty) {
                
            }else{
                for n in 0...moviesCoreData.count-1{
                    
                    let objetToDelete = moviesCoreData[n] as! NSManagedObject
                    
                    managedContext.delete(objetToDelete)
                    
                    
                    try managedContext.save()
                    
                }
            }
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return true
    }
    
    func getMoviesFromRestAPI() -> Bool {
     
        let urlString = "https://api.androidhive.info/json/movies.json"
        guard let url = URL(string: urlString) else { return false}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing
            do {
                
                //Decode retrived data with JSONDecoder and assing type of Article object
                let moviesData = try JSONDecoder().decode([ModelMovie].self, from: data)
                
                for movie in moviesData{
                    let code = ""
                    
                    //Get back to the main queue
                    DispatchQueue.main.async {
                        self.save(title: movie.title, image: movie.image, rating: movie.rating, releaseYear: movie.releaseYear, genre: movie.genre, barcode: code)
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()

        
        return true
    }
    
    func save(title: String, image: String, rating: Double, releaseYear: Double, genre: [String], barcode: String) {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(title, forKeyPath: "title")
        person.setValue(image, forKeyPath: "image")
        person.setValue(rating, forKeyPath: "rating")
        person.setValue(releaseYear, forKeyPath: "releaseYear")
        person.setValue(genre.description, forKeyPath: "genre")
        person.setValue(barcode, forKeyPath: "barcode")
        

        do {
            try managedContext.save()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            _ = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func saveRX() {
        
        let movies = MovieList(title: "title", image: "d", rating: 2.0, releaseYear: 2.0, genre: ["string"])
        movieSubject.onNext(movies)
        
        
        
    }


}

