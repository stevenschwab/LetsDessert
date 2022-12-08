//
//  ImageStore.swift
//  Let's Dessert
//
//  Created by Steven Schwab on 12/6/22.
//

import UIKit

enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
    case missingMealID
}

class ImageStore {
    
    let cache = NSCache<NSString,UIImage>()
    
    // Saving image data to disk
    private func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: url)
            } catch {
                print("Error turning image into JPEG data, \(error.localizedDescription).")
            }
        }
    }
    
    // Returning image from cache, else from filesystem
    private func image(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else { return nil }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    // Create a URL in the documents directory using a meal id
    private func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appending(path: key)
    }
    
    // Checking if image is in cache, otherwise fetching from API
    func fetchImage(for meal: MealItem, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        if let photoKey = meal.idMeal {
            if let image = image(forKey: photoKey) {
                OperationQueue.main.addOperation {
                    completion(.success(image))
                }
                
                return
                
            } else {
                guard let photoUrl = meal.strMealThumb else {
                    completion(.failure(PhotoError.missingImageURL))
                    return
                }
                
                if let url = URL(string: photoUrl) {
                    let session = URLSession(configuration: .default)
                    let task = session.dataTask(with: url) { (data, response, error) in
                        
                        let result = self.processImageRequest(data: data, error: error)
                        
                        if case let .success(image) = result {
                            self.setImage(image, forKey: photoKey)
                        }
                        
                        OperationQueue.main.addOperation {
                            completion(result)
                        }
                    }
                    task.resume()
                }
            }
        }
        
        completion(.failure(PhotoError.missingMealID))
        
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard let imageData = data, let image = UIImage(data: imageData) else {
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        
        return .success(image)
    }
}
