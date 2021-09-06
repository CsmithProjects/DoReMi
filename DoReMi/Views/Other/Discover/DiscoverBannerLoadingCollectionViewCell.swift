//
//  DiscoverBannerLoadingCollectionViewCell.swift
//  DoReMi
//
//  Created by Conor Smith on 8/18/21.
//

import UIKit

class DiscoverBannerLoadingCollectionViewCell: UICollectionViewCell {
    static let identifier = "DiscoverBannerLoadingCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        imageView.frame = contentView.bounds
        label.frame = CGRect(x: 10, y: contentView.height - 5 - label.height, width: label.width, height: label.height)
        contentView.bringSubviewToFront(label)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        let gradientLayer = AnimationsManager.shared.shimmerAnimation()
        gradientLayer.frame = contentView.frame
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        contentView.backgroundColor = .systemGray6
        animation.duration = 1
        animation.fromValue = -contentView.width
        animation.toValue = contentView.width
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "shimmer")
        contentView.layer.addSublayer(gradientLayer)
    }
    
    func configure(with viewModel: DiscoverBannerViewModel) {
        imageView.image = viewModel.image
        label.text = viewModel.title
    }
}
