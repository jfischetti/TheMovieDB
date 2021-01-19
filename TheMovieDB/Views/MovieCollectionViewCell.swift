//
//  MovieCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import Foundation
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        saveImage.image = nil
        titleLbl.text = nil
    }
}
