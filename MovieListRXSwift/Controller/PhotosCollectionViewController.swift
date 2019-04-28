//
//  PhotosCollectionViewController.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/24/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController {
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    private let selectedPathImage = PublishSubject<String>()
    
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    var selectedPath: Observable<String> {
        return selectedPathImage.asObservable()
    }
    
    private var images = [PHAsset]()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        populatePhotos()
        setNavigationTopBar()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, info in
            
            guard let info = info else { return }
            
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegradedImage {
                
                selectedAsset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (eidtingInput, info) in
                    if let input = eidtingInput, let imgURL = input.fullSizeImageURL {
                        let path:String = imgURL.description
                        self?.selectedPathImage.onNext(path)
                    }
                }
                if let image = image {
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("PhotoCollectionViewCell is not found")
        }
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
            
        }
        
        return cell
        
    }
    
    private func populatePhotos() {
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            
            if status == .authorized {
                
                // access the photos from photo library
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
            }
            
        }
        
    }
    
    func setNavigationTopBar() {
        navigationItem.title = "Pick Up Photo"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:  UIImage(named: "x_button.png"), style: .plain, target: self, action: nil)
        
        if let rightBtn = navigationItem.rightBarButtonItem {
            rightBtn.rx.tap.subscribe{ _ in
                self.dismiss(animated: true, completion: nil)

                }.disposed(by: disposeBag)
        }
    }
    
}
