//
//  DiscoverPostViewModel.swift
//  DoReMi
//
//  Created by Conor Smith on 7/14/21.
//

import Foundation
import UIKit

struct DiscoverPostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}
