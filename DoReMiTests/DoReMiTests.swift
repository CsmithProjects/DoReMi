//
//  DoReMiTests.swift
//  DoReMiTests
//
//  Created by Conor Smith on 9/3/21.
//

import XCTest

@testable import DoReMi

class DoReMiTests: XCTestCase {
    func testPostModelChildPath() {
        let id = UUID().uuidString
        let user = User(
            username: "Bill Gates",
            profilePictureURL: nil,
            identifier: "123"
        )
        let post = PostModel(identifier: id, user: user)
        XCTAssertEqual(post.videoChildPath, "abcdefg")
    }
}
