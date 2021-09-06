//
//  DiscoverHashtagLoadingCollectionViewCell.swift
//  DoReMi
//
//  Created by Conor Smith on 8/21/21.
//

import UIKit

class DiscoverHashtagLoadingCollectionViewCell: UICollectionViewCell {
    static let identifier = "DiscoverHashtagLoadingCollectionViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let hashtagLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.backgroundColor = .systemGray6
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        contentView.addSubview(hashtagLabel)
        contentView.backgroundColor = .systemGray5
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = contentView.height/3
        iconImageView.frame = CGRect(
            x: 10,
            y: (contentView.height - iconSize)/2,
            width: iconSize,
            height: iconSize
        ).integral
        
        hashtagLabel.sizeToFit()
        hashtagLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 10,
            height: contentView.height
        ).integral
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hashtagLabel.text = nil
        iconImageView.image = nil
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        createSublayer(view: iconImageView)
        createSublayer(view: hashtagLabel)
    }
    
    func configure(with viewModel: DiscoverHashtagViewModel) {
        hashtagLabel.text = viewModel.text
        iconImageView.image = viewModel.icon
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
