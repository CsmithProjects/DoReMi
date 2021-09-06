//
//  PostModel.swift
//  DoReMi
//
//  Created by Conor Smith on 7/6/21.
//

import Foundation

struct PostModel {
    let identifier: String
    let user: User
    var filename: String = ""
    var caption: String = ""

    var isLikedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(
                identifier: UUID().uuidString,
                user: User(
                    username: "kanyewest",
                    profilePictureURL: nil,
                    coverPictureURL: nil,
                    identifier: UUID().uuidString
                )
            )
            posts.append(post)
        }
        return posts
    }
    
    /// Represents database child path for this post in a given user node
    var videoChildPath: String {
        return "videos/\(user.username.lowercased())/\(filename)"
    }
}
