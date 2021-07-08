//
//  ProfileViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 6/30/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
    }
    
    
    

}
