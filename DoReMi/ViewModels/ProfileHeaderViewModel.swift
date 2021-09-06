//
//  ProfileHeaderViewModel.swift
//  DoReMi
//
//  Created by Conor Smith on 8/11/21.
//

import Foundation

struct ProfileHeaderViewModel {
    let avatarImageURL: URL?
    let coverPhotoImageURL: URL?
    let followerCount: Int
    let followingCount: Int
    let isFollowing: Bool?
}
