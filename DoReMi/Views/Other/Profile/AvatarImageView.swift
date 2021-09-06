//
//  AvatarImageView.swift
//  DoReMi
//
//  Created by Conor Smith on 9/6/21.
//

import UIKit

class AvatarImageView: UIImageView {

    override init(image: UIImage?) {
        super.init(image: image)
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
        backgroundColor = .secondarySystemBackground
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
