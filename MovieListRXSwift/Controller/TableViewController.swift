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
import SDWebImage


class TableViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var movieListViewModel = MovieListViewModel()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTopBar()
        populateTodoListTableView()
        setupMovieListTableViewCellWhenTapped()
        setupMovieListTableViewCellWhenDeleted()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReloadTableView()
    }
    
    
    private func populateTodoListTableView() {
            
        let observableMovies = movieListViewModel.getMovies().asObservable()
        
        observableMovies.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: TableViewCell.self)) { (row, element, cell) in
            
            let imageURL = URL(string: element.image!)
            
            cell.titleLabel.text = element.title
            cell.releaseYearLabel.text = element.releaseYear 
            cell.genreLabel.text = element.genre
            cell.ratingLabel.text = element.rating
            cell.barcodeLabel.text = element.barcode
            cell.imageviewCell?.sd_setImage(with: imageURL, completed:nil)

            if element.isCompleted {
                cell.accessoryType = .checkmark
                
            } else {
                cell.accessoryType = .none
            }
        }
            .disposed(by: disposeBag)
    }
    
     // MARK: - subscribe to todoListTableView when item has been selected, then toggle todo to persistent storage via viewmodel
    private func setupMovieListTableViewCellWhenTapped() {
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: false)
                self.movieListViewModel.toggleMovieIsCompleted(withIndex: indexPath.row)
            })
            .disposed(by: disposeBag)
    }

    
    // MARK: - subscribe to todoListTableView when item has been deleted, then remove todo to persistent storage via viewmodel
    private func setupMovieListTableViewCellWhenDeleted() {
        tableView.rx.itemDeleted
            .subscribe(onNext : { indexPath in
                self.movieListViewModel.removeMovie(withIndex: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "indentifier" {
            let dest = segue.destination as! PreviewViewController
            
            tableView.rx.itemSelected
                .subscribe(onNext: { indexPath in
                   let row =  indexPath.row
                    dest.movieIndexRow = row
                    
                    
                })
                .disposed(by: disposeBag)

        }
    }
    
    // MARK: - add title and add right button to segue
    
    func setNavigationTopBar() {
        navigationItem.title = "Movie List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: nil)
        if let rightBtn = navigationItem.rightBarButtonItem {
            rightBtn.rx.tap.subscribe{ _ in
                self.performSegue(withIdentifier: "yourIdentifierInStoryboard", sender: self)
                
                }.disposed(by: disposeBag)
        }
    }
    
    func ReloadTableView()  {
        self.tableView.reloadData()
    }
    
    
}
