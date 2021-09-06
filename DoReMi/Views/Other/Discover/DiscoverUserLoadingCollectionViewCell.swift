//
//  DiscoverUserLoadingCollectionViewCell.swift
//  DoReMi
//
//  Created by Conor Smith on 8/21/21.
//

import UIKit

class DiscoverUserLoadingCollectionViewCell: UICollectionViewCell {
    static let identifier = "DiscoverUserLoadingCollectionViewCell"
    
    private let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = .systemGray6
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(profilePicture)
        contentView.addSubview(usernameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 55
        profilePicture.frame = CGRect(
            x: (contentView.width - imageSize)/2,
            y: 0,
            width: imageSize,
            height: imageSize
        )
        
        profilePicture.layer.cornerRadius = profilePicture.height/2
        
        usernameLabel.frame = CGRect(
            x: 0,
            y: profilePicture.bottom + 16,
            width: contentView.width,
            height: 22
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        profilePicture.image = nil
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        createSublayer(view: profilePicture)
        createSublayer(view: usernameLabel)
    }
    
    func configure(with viewModel: DiscoverUserViewModel) {
        usernameLabel.text = viewModel.username
        profilePicture.image = viewModel.profilePicture
        createSublayer(view: profilePicture)
        createSublayer(view: usernameLabel)
    }
    
    func createSublayer(view: UIView) {
        let gradientLayer = AnimationsManager.shared.shimmerAnimation()
        gradientLayer.frame = view.bounds
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1
        animation.fromValue = -contentView.width
        animation.toValue = contentView.width
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "shimmer")
        view.layer.addSublayer(gradientLayer)
    }
}
