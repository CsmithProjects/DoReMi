//
//  DiscoverUserViewModel.swift
//  DoReMi
//
//  Created by Conor Smith on 7/14/21.
//

import Foundation
import UIKit

struct DiscoverUserViewModel {
    let profilePictureURL: URL?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
