//
//  DiscoverBannerViewModel.swift
//  DoReMi
//
//  Created by Conor Smith on 7/14/21.
//

import Foundation
import UIKit

struct DiscoverBannerViewModel {
    let image: UIImage?
    let title: String
    let handler: (() -> Void)
}
