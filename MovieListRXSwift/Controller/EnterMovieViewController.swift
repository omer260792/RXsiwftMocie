//
//  EnterMovieViewController.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/24/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CoreData
import SDWebImage

class EnterMovieViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var releaseYearEditText: UITextField!
    @IBOutlet var titleEditText: UITextField!
    @IBOutlet var ratingEditText: UITextField!
    @IBOutlet var barcodeEditText: UITextField!
    @IBOutlet var genreEditText: UITextField!
    @IBOutlet var addImageOutlet: UIButton!
    @IBOutlet var addBarcodeOutlet: UIButton!
    @IBOutlet var saveMovieOutlet: UIButton!
    
    let disposeBag = DisposeBag()
    var movieListViewModel = MovieListViewModel()
    
    var titleMovie = ""
    var image = ""
    var rating = 0.0
    var releaseYear = 0.0
    var genre = ""
    var barcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      saveMovie()
        
    }
    
    
    func addImageMovie()  {
        if let addImage = addImageOutlet {
        
        }
    }

    func saveMovie()  {
        if let addMovie = saveMovieOutlet {
            addMovie.rx.tap.subscribe{ _ in
                
                if self.releaseYearEditText.text != "" {
                    self.releaseYear = Double((self.releaseYearEditText.text!)) ?? 0
                }
                if self.titleEditText.text != "" {
                    self.titleMovie = self.titleEditText.text!
                }
                
                if self.ratingEditText.text != "" {
                    self.rating = Double((self.ratingEditText.text!)) ?? 0
                }
             
                if self.barcodeEditText.text != "" {
                    self.barcode = self.barcodeEditText.text!
                }
                
                if self.genreEditText.text != "" {
                }
                
                self.movieListViewModel.addMovie(withMovie: self.releaseYear, title: self.titleMovie, image: self.image, rating: self.rating, genre: [self.genre] , barcode: self.barcode)
                
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                
                }.disposed(by: disposeBag)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
            let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
                fatalError("Segue destination is not found")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    private func updateUI(with image: UIImage) {
        self.imageView.image = image
    }
}
