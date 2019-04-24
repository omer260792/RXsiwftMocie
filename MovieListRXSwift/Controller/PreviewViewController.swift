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
   
            let imageURL = URL(string: (Event.element?.suffix(from: self.movieIndexRow!).first?.image)!)
            self.imageView.sd_setImage(with: imageURL, completed: nil)
            self.genreLabel.text = Event.element?.suffix(from: self.movieIndexRow!).first?.genre
            self.titleLabel.text = Event.element?.suffix(from: self.movieIndexRow!).first?.title
            self.releaseYearLabel.text = Event.element?.suffix(from: self.movieIndexRow!).first?.releaseYear
            self.ratingLabel.text = Event.element?.suffix(from: self.movieIndexRow!).first?.rating
            self.barcodeLabel.text = Event.element?.suffix(from: self.movieIndexRow!).first?.barcode

            }).disposed(by: disposeBag)
    }
    


}
