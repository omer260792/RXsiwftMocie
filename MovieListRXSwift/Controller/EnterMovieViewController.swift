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
import Photos


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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
        self.hideKeyboardWhenTappedAround()
    }
    
    func saveMovie()  {
        if let addMovie = saveMovieOutlet {
            addMovie.rx.tap.subscribe{ _ in
                
                if let barcode = self.barcodeEditText.text {
                    self.barcode = barcode
                }
                
                if let rating = self.ratingEditText.text {
                    self.rating = Double(rating) ?? 0
                }
                
                if let title = self.titleEditText.text {
                    self.title = title
                }
                
                if let releaseYear = self.releaseYearEditText.text {
                    self.releaseYear = Double(releaseYear) ?? 0
                }
                
                if let genre = self.genreEditText.text {
                      self.genre = genre
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
        photosCVC.selectedPath.subscribe(onNext: { string in
            self.savePath(with: string)
           
            
        }).disposed(by: disposeBag)
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
                
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    private func updateUI(with image: UIImage) {
        self.imageView.image = image
    }
    
    private func savePath (with path: String) {
        self.image = path
        
    }
    override func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
