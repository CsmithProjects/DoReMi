//
//  CoverPhotoImageView.swift
//  DoReMi
//
//  Created by Conor Smith on 9/6/21.
//

import UIKit

class CoverPhotoImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
