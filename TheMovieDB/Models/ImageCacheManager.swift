//
//  ImageCacheManager.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/16/21.
//

import Foundation
import UIKit

class ImageCacheManager {

    static let shared = ImageCacheManager()
    
    func getCachedImage(by id: String) -> UIImage? {
        let imagePath = getImagePath(imageId: id)
        let url = URL(fileURLWithPath: imagePath)
        if let imageData = try? Data(contentsOf: url) {
            return UIImage(data: imageData)
        }

        return nil
    }

    func cacheImage(image: UIImage, with id: String) {
        let imagePath = getImagePath(imageId: id)
        let imageData = image.pngData()
        let url = URL(fileURLWithPath: imagePath)
        try? imageData?.write(to: url, options: .atomic)

    }

    func deleteImage(with id: String) {
        let imagePath = getImagePath(imageId: id)
        try? FileManager.default.removeItem(atPath: imagePath)
    }

    func getImagePath(imageId: String) -> String {
        let documentsDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectoryURL.appendingPathComponent(imageId).path
    }
}
