//
//  ProfileManager.swift
//  DoReMi
//
//  Created by Conor Smith on 7/29/21.
//

import Foundation
import UIKit

protocol ProfileManagerDelegate: AnyObject {
    func pushViewController(_ vc: UIViewController)
    func didTapHashtag(_ hashtag: String)
}

final class ProfileManager {
//    static let shared = ProfileManager()
//
//    weak var delegate: ProfileManagerDelegate?
//
//    enum BannerAction: String {
//        case post
//        case hashtag
//        case user
//    }
//
//    //MARK: - Public
//
//    public func getProfileBanners() -> [ProfileBannerViewModel] {
//        guard let profileData = parseDiscoverData() else {
//            return []
//        }
//        return profileData.banners.compactMap({ model in
//            DiscoverBannerViewModel(
//                image: UIImage(named: model.image),
//                title: model.title
//            ) { [weak self] in
//                guard let action = BannerAction(rawValue: model.action) else {
//                    return
//                }
//                DispatchQueue.main.async {
//                    let vc = UIViewController()
//                    vc.view.backgroundColor = .systemBackground
//                    vc.title = action.rawValue.uppercased()
//                    self?.delegate?.pushViewController(vc)
//                }
//                switch action {
//                case .user:
//                    // profile
//                    break
//                case .post:
//                    // post
//                    break
//                case .hashtag:
//                    // search for hashtag
//                    break
//                }
//            }
//        })
//    }
//
//
//    public func getProfileCreators() -> [ProfileUserViewModel] {
//        guard let discoverData = parseDiscoverData() else {
//            return []
//        }
//        return discoverData.creators.compactMap({ model in
//            DiscoverUserViewModel(
//                profilePicture: UIImage(named: model.image),
//                username: model.username,
//                followerCount: model.followers_count
//            ) { [weak self] in
//                DispatchQueue.main.async {
//                    let userID = model.id
//                    // Fetch user object from firebase
//                    let vc = ProfileViewController(user: User(username: "joe", profilePictureURL: nil, identifier: userID))
//                    self?.delegate?.pushViewController(vc)
//                }
//            }
//        })
//    }
//
//    // MARK: - Private
//
//    private func parseDiscoverData() -> DiscoverResponse? {
//        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
//            return nil
//        }
//        do {
//            let url = URL(fileURLWithPath: path)
//            let data = try Data(contentsOf: url)
//            return try JSONDecoder().decode(
//                DiscoverResponse.self,
//                from: data
//            )
//        }
//        catch {
//            print(error)
//            return nil
//        }
//    }
}

//struct DiscoverResponse: Codable {
//    let banners: [Banner]
//    let trendingPosts: [Post]
//    let creators: [Creator]
//    let recentPosts: [Post]
//    let hashtags: [Hashtag]
//    let popular: [Post]
//    let recommended: [Post]
//}
//
//struct Banner: Codable {
//    let id: String
//    let image: String
//    let title: String
//    let action: String
//}
//
//struct Post: Codable {
//    let id: String
//    let image: String
//    let caption: String
//}
//
//struct Hashtag: Codable {
//    let image: String
//    let tag: String
//    let count: Int
//}
//
//struct Creator: Codable {
//    let id: String
//    let image: String
//    let username: String
//    let followers_count: Int
//}
