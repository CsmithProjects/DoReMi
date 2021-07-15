//
//  DiscoverHashtagViewModel.swift
//  DoReMi
//
//  Created by Conor Smith on 7/14/21.
//

import Foundation
import UIKit

struct DiscoverHashtagViewModel {
    let icon: UIImage?
    let text: String
    let count: Int // number of posts associated with tag
    let handler: (() -> Void)
}
