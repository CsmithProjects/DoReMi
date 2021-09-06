//
//  DiscoverPostLoadingCollectionViewCell.swift
//  DoReMi
//
//  Created by Conor Smith on 8/21/21.
//

import UIKit

class DiscoverPostLoadingCollectionViewCell: UICollectionViewCell {
    static let identifier = "DiscoverPostLoadingCollectionViewCell"
    
    private let thumbnailImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.backgroundColor = .systemGray6
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(captionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let captionHeight = contentView.height / 5
        thumbnailImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.width,
            height: contentView.height-captionHeight - 6
        )
        captionLabel.frame = CGRect(
            x: 0,
            y: contentView.height-captionHeight + 6,
            width: contentView.width,
            height: 22
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        captionLabel.text = nil
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        createSublayer(view: thumbnailImageView)
        createSublayer(view: captionLabel)
    }
    
    func configure(with viewModel: DiscoverPostViewModel) {
        captionLabel.text = viewModel.caption
        thumbnailImageView.image = viewModel.thumbnailImage
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
