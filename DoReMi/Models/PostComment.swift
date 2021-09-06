//
//  PostComment.swift
//  DoReMi
//
//  Created by Conor Smith on 7/7/21.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(username: "kanyewest", profilePictureURL: nil, coverPictureURL: nil, identifier: UUID().uuidString)
        
        var comments = [PostComment]()
        
        let text = [
            "This is cool",
            "this is rad",
            "Im learning"
        ]
        
        for comment in text {
            comments.append(
                PostComment(
                    text: comment,
                    user: user,
                    date: Date()
                )
            )
        }
        
        return comments
    }
}
