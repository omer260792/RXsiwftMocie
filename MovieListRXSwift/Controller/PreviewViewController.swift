//
//  PreviewViewController.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/24/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData
import RxCocoa
import RxSwift


class PreviewViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var barcodeLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var releaseYearLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    var movieIndexRow: Int?
    
    let disposeBag = DisposeBag()
    var movieListViewModel = MovieListViewModel()
    var movie = PublishSubject<Movie>()

    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieByIndex()
    }
    
    func getMovieByIndex()  {
        let observableMovies = movieListViewModel.getMovies().asObservable()
        observableMovies.subscribe({ Event in
            if let movieIndex = self.movieIndexRow {
                
                if let imageURL = Event.element?.suffix(from: movieIndex).first?.image{
                    self.imageView.sd_setImage(with: URL(string: imageURL), completed: nil)

                }
                
                if let title = Event.element?.suffix(from: movieIndex).first?.title {
                    self.titleLabel.text = title
                }
   
                if let releaseYear = Event.element?.suffix(from: movieIndex).first?.releaseYear {
                    self.releaseYearLabel.text = releaseYear
                }
                
                if let rating = Event.element?.suffix(from: movieIndex).first?.rating {
                    self.ratingLabel.text = rating
                }
                
                if let genre = Event.element?.suffix(from: movieIndex).first?.genre {
                    self.genreLabel.text = genre
                }
                
                if let barcode = Event.element?.suffix(from: movieIndex).first?.barcode {
                     self.barcodeLabel.text = barcode
                }
                
            }
        }).disposed(by: disposeBag)
    }
    


}
