//
//  ImageCacheManager.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/16/21.
//

import Foundation
import UIKit

/// Handles storing and fetching of images.
class ImageCacheManager {

    static let shared = ImageCacheManager()

    /// Fetches an image from disk.
    /// - Parameter id: The filename to store the image under.
    /// - Returns: The fetched image or nil if not found.
    func getCachedImage(by id: String) -> UIImage? {
        let imagePath = getImagePath(imageId: id)
        let url = URL(fileURLWithPath: imagePath)
        if let imageData = try? Data(contentsOf: url) {
            return UIImage(data: imageData)
        }

        return nil
    }

    /// Stores an image to disk.
    /// - Parameters:
    ///   - image: The image to store.
    ///   - id: The filename to store the image under.
    func cacheImage(image: UIImage, with id: String) {
        let imagePath = getImagePath(imageId: id)
        let imageData = image.pngData()
        let url = URL(fileURLWithPath: imagePath)
        try? imageData?.write(to: url, options: .atomic)

    }

    /// Removes an image from disk.
    /// - Parameter id: The filename the image is stored under.
    func deleteImage(with id: String) {
        let imagePath = getImagePath(imageId: id)
        try? FileManager.default.removeItem(atPath: imagePath)
    }


    /// Constructs the URL path for an image to fetch from disk.
    /// - Parameter imageId: The filename the image is stored under.
    /// - Returns: The URL path string for the file on disk.
    func getImagePath(imageId: String) -> String {
        let documentsDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectoryURL.appendingPathComponent(imageId).path
    }
}
