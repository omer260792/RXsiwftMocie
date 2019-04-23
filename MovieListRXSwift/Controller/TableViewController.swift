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


class TableViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var movieListViewModel = MovieListViewModel()


    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let observableMovies = movieListViewModel.getMovies().asObservable()
        
        observableMovies.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: TableViewCell.self)) { (row, element, cell) in
            
            cell.titleLabel.text = element.title
            
            if element.isCompleted {
                cell.accessoryType = .checkmark
                
            } else {
                cell.accessoryType = .none
            }
            
            }
            
            .disposed(by: disposeBag)

    }
    
    
    
    

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 1
//    }

//
//         let observableMovies = movieListViewModel.getMovies().asObservable()
        
        //let movie = moviesCoreData[indexPath.row]
//        
//        cell.titleLabel.text = movie.value(forKey: "title") as? String
//        cell.ratingLabel.text = String(movie.value(forKey: "rating") as! Double)
//        cell.releaseYearLabel.text = String(movie.value(forKey: "releaseYear") as! Double)
//        cell.genreLabel.text = movie.value(forKey: "genre") as? String
////        cell.imageview.sd_setImage(with: URL(string: movie.value(forKey: "image") as! String), placeholderImage: UIImage(named: "defaultImg.png"))
        
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func loadDataFromCoreData()  {
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        do {
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
//            let movies = try managedContext.fetch(fetchRequest)
//            
//            for movie in movies{
//                appDelegate.movies.append(movie)
//            }
//            moviesCoreData = appDelegate.movies
//            tableView.reloadData()
//            
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
//
//    func  reloadtableViewData() {
//        tableView.reloadData()
//
//    }

}
