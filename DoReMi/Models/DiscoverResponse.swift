//
//  DiscoverResponse.swift
//  DoReMi
//
//  Created by Conor Smith on 9/3/21.
//

import Foundation

struct DiscoverResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}
