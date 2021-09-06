//
//  DiscoverManager.swift
//  DoReMi
//
//  Created by Conor Smith on 7/19/21.
//

import Foundation
import UIKit

/// Delegate interface to notify manager events
protocol DiscoverManagerDelegate: AnyObject {
    /// Notify a view controller should be pushed
    /// - Parameter vc: The view controller to present
    func pushViewController(_ vc: UIViewController, _ isPostVC: Bool)
    /// Notify a hashtag element was tapped
    /// - Parameter hashtag: The hashtag that was tapped
    func didTapHashtag(_ hashtag: String)
    func didTapCommentsButton(_ vc: UIViewController)
}

/// Manager that handles Discover view content
final class DiscoverManager: UIViewController {
    /// Shared singleton instance
    static let shared = DiscoverManager()
    
    /// Delegate to notify of events
    weak var delegate: DiscoverManagerDelegate?
    
    /// Represents banner action type
    enum BannerAction: String {
        /// Post type
        case post
        /// Hashtag search type
        case hashtag
        /// User type
        case user
    }
    
    //MARK: - Public
    
    /// Gets Discover data for banners
    /// - Returns: Return collection of models
    public func getDiscoverBanners() -> [DiscoverBannerViewModel] {
        guard let discoverData = parseDiscoverData() else {
            return []
        }
        return discoverData.banners.compactMap({ model in
            DiscoverBannerViewModel(
                image: UIImage(named: model.image),
                title: model.title
            ) { [weak self] in
                guard let action = BannerAction(rawValue: model.action) else {
                    return
                }
                DispatchQueue.main.async {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .systemBackground
                    vc.title = action.rawValue.uppercased()
                    vc.hidesBottomBarWhenPushed = true
                    self?.delegate?.pushViewController(vc, false)
                }
                switch action {
                case .user:
                    // profile
                    break
                case .post:
                    // post
                    break
                case .hashtag:
                    // search for hashtag
                    break
                }
            }
        })
    }
    
    /// Gets Discover data for popular creators
    /// - Returns: Return collection of models
    public func getDiscoverCreators() -> [DiscoverUserViewModel] {
        guard let discoverData = parseDiscoverData() else {
            return []
        }
        return discoverData.creators.compactMap({ model in
            DiscoverUserViewModel(
                profilePicture: UIImage(named: model.image),
                username: model.username,
                followerCount: model.followers_count
            ) { [weak self] in
                DispatchQueue.main.async {
                    let userID = model.id
                    // Fetch user object from firebase
                    let vc = ProfileViewController(user: User(username: "joe", profilePictureURL: nil, coverPictureURL: nil, identifier: userID))
                    vc.hidesBottomBarWhenPushed = true
                    self?.delegate?.pushViewController(vc, false)
                }
            }
        })
    }
    
    /// Gets Discover data for hashtags
    /// - Returns: Return collection of models
    public func getDiscoverHashtags() -> [DiscoverHashtagViewModel] {
        guard let discoverData = parseDiscoverData() else {
            return []
        }
        return discoverData.hashtags.compactMap({ model in
            DiscoverHashtagViewModel(
                icon: UIImage(systemName: model.image),
                text: "#" + model.tag,
                count: model.count
            ) { [weak self] in
                DispatchQueue.main.async {
                    self?.delegate?.didTapHashtag(model.tag)
                }
            }
        })
    }
    
    /// Gets Discover data for trending posts
    /// - Returns: Return collection of models
    public func getDiscoverTrendingPosts() -> [DiscoverPostViewModel] {
        guard let discoverData = parseDiscoverData() else {
            return []
        }
        return discoverData.trendingPosts.compactMap({ model in
            DiscoverPostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                // use id to fetch post from firebase
                DispatchQueue.main.async { [self] in
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(
                        username: "kanyewest",
                        profilePictureURL: nil,
                        coverPictureURL: nil,
                        identifier: UUID().uuidString
                    )))
                    vc.hidesBottomBarWhenPushed = true
                    vc.delegate = self
                    self?.delegate?.pushViewController(vc, true)
                }
            }
        })
    }
    
    /// Gets Discover data for recent posts
    /// - Returns: Return collection of models
    public func getDiscoverRecentPosts() -> [DiscoverPostViewModel] {
        guard let discoverData = parseDiscoverData() else {
            return []
        }
        return discoverData.recentPosts.compactMap({ model in
            DiscoverPostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                // use id to fetch post from firebase
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(
                        username: "kanyewest",
                        profilePictureURL: nil,
                        coverPictureURL: nil,
                        identifier: UUID().uuidString
                    )))
                    vc.hidesBottomBarWhenPushed = true
                    self?.delegate?.pushViewController(vc, true)
                }
            }
        })
    }
    
    /// Gets Discover data for popular posts
    /// - Returns: Return collection of models
    public func getDiscoverPopularPosts() -> [DiscoverPostViewModel] {
        guard let discoverData = parseDiscoverData() else {
            return []
        }
        return discoverData.popular.compactMap({ model in
            DiscoverPostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                // use id to fetch post from firebase
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(
                        username: "kanyewest",
                        profilePictureURL: nil,
                        coverPictureURL: nil,
                        identifier: UUID().uuidString
                    )))
                    vc.hidesBottomBarWhenPushed = true
                    self?.delegate?.pushViewController(vc, true)
                }
            }
        })
    }
    
    // MARK: - Private
    
    /// Parses Discover JSON data
    /// - Returns: Returns a optional response model
    private func parseDiscoverData() -> DiscoverResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            return nil
        }
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(
                DiscoverResponse.self,
                from: data
            )
        }
        catch {
            print(error)
            return nil
        }
    }
}

extension DiscoverManager: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        let vc = CommentsViewController(post: post)
        vc.delegate = self
        self.delegate?.didTapCommentsButton(vc)
    }
    
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        let user = post.user
        let vc = ProfileViewController(user: user)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBack))
        vc.navigationController?.navigationBar.tintColor = .label
        self.delegate?.pushViewController(vc, false)
    }
    
    @objc func didTapBack() {
        //Empty tap
    }
}

extension DiscoverManager: CommentsViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentsViewController) {
        //close comment with animation
        let frame = viewController.view.frame
        UIView.animate(withDuration: 0.2) {
            //viewController.view.frame = CGRect(x: 0, y: self.view.height, width: frame.width, height: frame.height)
        } completion: { done in
            if done {
                DispatchQueue.main.async {
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                }
            }
        }
    }
}
