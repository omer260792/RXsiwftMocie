//
//  TableViewCell.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/23/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var releaseYearLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var barcodeLabel: UILabel!
    
    @IBOutlet var imageviewCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
