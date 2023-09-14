//
//  ImageLoader.swift
//  Weather_APP
//
//  Created by Ge Ding on 6/19/23.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let fileManager = FileManager.default
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var cancellable: AnyCancellable?
    
    /// Load the image from the specified imageName
    ///
    /// - Parameter imageName: The name of the image to load.
    /// - Returns: A publisher that emits the loaded image or an error.
    func loadImage(from imageName: String) -> AnyPublisher<UIImage?, Error> {
        guard let url = createURL(imageName: imageName) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        if let cachedImage = loadCachedImageFromDisk(with: url) {
            // Use the image from the disk cache
            self.image = cachedImage
            return Just(cachedImage)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, _ -> UIImage in
                    guard let image = UIImage(data: data) else {
                        throw URLError(.cannotDecodeContentData)
                    }
                    return image
                }
                .mapError { error in
                    // Handle specific errors if needed here 
                    return error
                }
                .handleEvents(receiveOutput: { [weak self] image in
                    // Save the image to disk cache
                    if let unwrappedImage = image {
                        do {
                            try self?.saveImageToDisk(unwrappedImage, with: url)
                        } catch {
                            print("Error saving image: \(error)")
                        }
                    }
                })
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
    
    /// Create the URL for the image based on the imageName
    ///
    /// - Parameter imageName: The name of the image.
    /// - Returns: The URL for the image.
    private func createURL(imageName: String) -> URL? {
        guard let url = URL(string: "\(BaseURL.imageBaseURL)\(imageName)@2x.png") else {
            return nil
        }
        return url
    }
    
    /// Load the cached image from disk if available
    ///
    /// - Parameter url: The URL of the image.
    /// - Returns: The cached image if available, nil otherwise.
    private func loadCachedImageFromDisk(with url: URL) -> UIImage? {
        let filePath = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        guard fileManager.fileExists(atPath: filePath.path) else {
            return nil
        }
        return UIImage(contentsOfFile: filePath.path)
    }
    
    /// Save the image to disk cache
    ///
    /// - Parameters:
    ///   - image: The image to save.
    ///   - url: The URL of the image.
    private func saveImageToDisk(_ image: UIImage, with url: URL) throws{
        let filePath = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        if let imageData = image.pngData() {
            do {
                try imageData.write(to: filePath)
            } catch {
                throw ImageLoaderError.imageSaveError
            }
        }
    }
}

final class ImageCache {
    static let shared = ImageCache()
    private var cache = [String: UIImage]()
    
    ///Retrieves the cached image for the specified name.
    ///
    ///- Parameter name: The name associated with the image.
    ///- Returns: The cached `UIImage` if found, otherwise `nil`.
    func image(for name: String) -> UIImage? {
        return cache[name]
    }
    
    ///Saves the specified image in the cache for the given name.
    ///
    ///- Parameters:
    ///   - image: The image to be cached.
    ///   - name: The name associated with the image
    func saveImage(_ image: UIImage, for name: String) {
        cache[name] = image
    }
}

enum ImageLoaderError: Error {
    case invalidURL
    case invalidImageData
    case imageSaveError
}


