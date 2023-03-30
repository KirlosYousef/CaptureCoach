//
//  ImageService.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 28/03/2023.
//

import UIKit

/**
 This class provides functions to download and cache images from URLs.
 */
class ImageService {
    /**
     Downloads an image from a given URL and loads it from the cache if it exists.
     Otherwise, downloads the image from the URL and saves it to the cache for future use.
     
     - Parameters:
     - url: The URL of the image to download.
     - completion: A closure to be called when the download is complete, with the downloaded image.
     */
    static func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        // Get the file URL where the image will be saved or loaded from
        guard let fileUrl = getImageFileUrl(from: url) else {
            completion(nil)
            return
        }
        
        // If the image is already cached, load it from disk
        if let image = loadImage(from: fileUrl) {
            completion(image)
            return
        }
        
        // If the image is not cached, download it and save it to the cache
        downloadImage(from: url, to: fileUrl, completion: completion)
    }
    
    /**
     Returns the file URL where the image with the given URL should be cached.
     
     - Parameter url: The URL of the image to cache.
     
     - Returns: The file URL where the image should be cached, or nil if we couldn't get the documents directory URL.
     */
    static func getImageFileUrl(from url: String) -> URL? {
        // Use the last path component of the URL as the file name
        let fileName = url.components(separatedBy: "/").last!
        
        // Get the documents directory URL
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        // Append the file name to the documents directory URL to get the file URL
        return documentsUrl.appendingPathComponent(fileName)
    }
    
    /**
     Loads an image from the given file URL.
     
     - Parameter fileUrl: The file URL where the image is saved.
     
     - Returns: The loaded image, or nil if the image couldn't be loaded.
     */
    static func loadImage(from fileUrl: URL) -> UIImage? {
        return UIImage(contentsOfFile: fileUrl.path)
    }
    
    /**
     Downloads an image from the given URL and saves it to the given file URL.
     
     - Parameters:
     - url: The URL of the image to download.
     - fileUrl: The file URL where the downloaded image should be saved.
     - completion: A closure to be called when the download is complete, with the downloaded image.
     */
    private static func downloadImage(from url: String, to fileUrl: URL, completion: @escaping (UIImage?) -> Void) {
        // Perform the image download in a background thread to avoid blocking the main thread
        DispatchQueue.global().async {
            // Download the image data from the URL
            guard let data = try? Data(contentsOf: URL(string: url)!) else {
                // If the download fails, call the completion closure with nil
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Save the downloaded data to the file URL
            do {
                try data.write(to: fileUrl)
            } catch {
                // If the save fails, call the completion closure with nil
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Create a UIImage from the downloaded data
            let image = UIImage(data: data)
            
            // Return the downloaded image to the main thread
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
