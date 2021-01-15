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
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var saveImage: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        title.text = nil
        saveImage.image = nil
    }
}
