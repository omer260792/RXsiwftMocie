//
//  TableViewController.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/23/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CoreData


class TableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
 
    
  
    private var MovieLists = BehaviorRelay<[MovieList]>(value: [])
    private var filteredMovieList = [MovieList]()
    let disposeBag = DisposeBag()
    var moviesCoreData : [NSManagedObject] = []


    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        tableView.delegate = self
        tableView.dataSource = self
//        loadDataFromCoreData()
//        reloadtableViewData()
  
    
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return moviesCoreData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell

        
        let movie = moviesCoreData[indexPath.row]
        
        cell.titleLabel.text = movie.value(forKey: "title") as? String
        cell.ratingLabel.text = String(movie.value(forKey: "rating") as! Double)
        cell.releaseYearLabel.text = String(movie.value(forKey: "releaseYear") as! Double)
        cell.genreLabel.text = movie.value(forKey: "genre") as? String
//        cell.imageview.sd_setImage(with: URL(string: movie.value(forKey: "image") as! String), placeholderImage: UIImage(named: "defaultImg.png"))
        
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func loadDataFromCoreData()  {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            let movies = try managedContext.fetch(fetchRequest)
            
            for movie in movies{
                appDelegate.movies.append(movie)
            }
            moviesCoreData = appDelegate.movies
            tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func  reloadtableViewData() {
        tableView.reloadData()

    }

}
