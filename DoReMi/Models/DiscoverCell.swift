//
//  DiscoverCell.swift
//  DoReMi
//
//  Created by Conor Smith on 7/14/21.
//

import Foundation
import UIKit

enum DiscoverCell {
    case banner(viewModel: DiscoverBannerViewModel)
    case post(viewModel: DiscoverPostViewModel)
    case hashtag(viewModel: DiscoverHashtagViewModel)
    case user(viewModel: DiscoverUserViewModel)
}
