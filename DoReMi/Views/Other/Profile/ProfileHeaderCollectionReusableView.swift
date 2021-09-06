//
//  ProfileHeaderCollectionReusableView.swift
//  DoReMi
//
//  Created by Conor Smith on 8/10/21.
//

import SDWebImage
import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableView(
        _ header: ProfileHeaderCollectionReusableView,
        didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel
    )
    func profileHeaderCollectionReusableView(
        _ header: ProfileHeaderCollectionReusableView,
        didTapFollowersButtonWith viewModel: ProfileHeaderViewModel
    )
    func profileHeaderCollectionReusableView(
        _ header: ProfileHeaderCollectionReusableView,
        didTapFollowingButtonWith viewModel: ProfileHeaderViewModel
    )
    func profileHeaderCollectionReusableView(
        _ header: ProfileHeaderCollectionReusableView,
        didTapAvatarFor viewModel: ProfileHeaderViewModel
    )
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    var viewModel: ProfileHeaderViewModel?
    
    // Subviews
    
    // Follow or Edit Button
    private let primaryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemPink
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("0\nFollowers", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("0\nFollowing", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        addSubviews()
        configureButtons()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
//        avatarImageView.isUserInteractionEnabled = true
//        avatarImageView.addGestureRecognizer(tap)
        
    }
    
    @objc func didTapAvatar() {
        guard let viewModel = viewModel else {
             return
        }
        delegate?.profileHeaderCollectionReusableView(
            self,
            didTapAvatarFor: viewModel
        )
    }
    
    func addSubviews() {
        addSubview(primaryButton)
        addSubview(followersButton)
        addSubview(followingButton)
    }
    
    func configureButtons() {
        primaryButton.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        followersButton.frame = CGRect(x: (width - 210)/2, y: 300, width: 100, height: 44)
        followingButton.frame = CGRect(x: followersButton.right+10, y: 300, width: 100, height: 44)

        primaryButton.frame = CGRect(x: (width - 220)/2, y: followingButton.bottom + 15, width: 220, height: 44)
    }
    
    // Actions
    
    @objc func didTapPrimaryButton() {
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(
            self,
            didTapPrimaryButtonWith: viewModel
        )
    }
    
    @objc func didTapFollowersButton() {
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(
            self,
            didTapFollowersButtonWith: viewModel
        )
    }
    
    @objc func didTapFollowingButton() {
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(
            self,
            didTapFollowingButtonWith: viewModel
        )
    }
    
    func configure(with viewModel: ProfileHeaderViewModel) {
        self.viewModel = viewModel
        // set up our header
        followersButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)

        if let isFollowing = viewModel.isFollowing {
            primaryButton.backgroundColor = isFollowing ? .secondarySystemBackground : .systemPink
            primaryButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
        }
        else {
            primaryButton.backgroundColor = .secondarySystemBackground
            primaryButton.setTitle("Edit Profile", for: .normal)
        }
    }
}
