//
//  StorageManager.swift
//  DoReMi
//
//  Created by Conor Smith on 7/1/21.
//

import Foundation
import FirebaseStorage

/// Manager object that deals with Firebase Storage
final class StorageManager {
    /// Shared singleton instance
    public static let shared = StorageManager()
    
    /// Storage bucket reference
    private let storageBucket = Storage.storage().reference()
    
    /// Private constructor
    private init() {}
    
    //Public
    
    /// Upload a new user video to Firebase
    /// - Parameters:
    ///   - url: Local file url to video
    ///   - fileName: Desired video file upload
    ///   - completion: Async callback result closure
    public func uploadVideo(from url: URL, fileName: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
    
    /// Upload new profile picture
    /// - Parameters:
    ///   - image: New image to upload
    ///   - completion: Async callback of result
    public func uploadProfilePicture(with image: UIImage, completion: @escaping(Result<URL, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
        let path = "profile_pictures/\(username)/picture.png"
        
        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            }
            else {
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    
                    completion(.success(url))
                }
            }
        }
    }
    
    /// Generates a new file name
    /// - Returns: Returns a uniquely generated filename
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        
        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
    }
    
    /// Get download url of video post
    /// - Parameters:
    ///   - post: Post model to get url for
    ///   - completion: Async callback
    public func getDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>) -> Void) {
        storageBucket.child(post.videoChildPath).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let url = url {
                completion(.success(url))
            }
        }
    }
}
