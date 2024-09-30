//
//  VideoCacheManager.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 29/09/24.
//

import Foundation

class VideoCacheManager {
    static let shared = VideoCacheManager()
    
    private let fileManager = FileManager.default
    
    func cachedURL(forKey key: String) -> URL? {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDirectory.appendingPathComponent(key)
    }
    
    func cacheVideo(from url: URL, key: String, completion: @escaping (URL?) -> Void) {
        let destinationURL = cachedURL(forKey: key)

        // Check if the video is already cached
        if let destinationURL = destinationURL, FileManager.default.fileExists(atPath: destinationURL.path) {
            completion(destinationURL)
            return
        }

        // Download the video and save it to cache
        let task = URLSession.shared.downloadTask(with: url) { (localURL, response, error) in
            guard let localURL = localURL, error == nil else {
                completion(nil)
                return
            }

            do {
                try self.fileManager.moveItem(at: localURL, to: destinationURL!)
                completion(destinationURL)
            } catch {
                print("Error caching video: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
