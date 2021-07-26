//
//  TabBarViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 6/30/21.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var signInPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpControllers()
    }
    
    func presentSignInIfNeeded() {
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = SignInViewController()
            vc.completion = { [weak self] in
                self?.signInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: false, completion: nil)
        }
    }
    
    private func setUpControllers() {
        let home = HomeViewController()
        let discover = DiscoverViewController()
        let create = CreateViewController()
        let wallet = WalletViewController()
        let profile = ProfileViewController(
            user: User(username: "self",
                       profilePictureURL: nil,
                       identifier: "abc123"))
        
        home.title = "Home"
        create.title = "Create"
        wallet.title = "Wallet"
        profile.title = "Profile"
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: discover)
        let nav3 = UINavigationController(rootViewController: create)
        let nav4 = UINavigationController(rootViewController: wallet)
        let nav5 = UINavigationController(rootViewController: profile)
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()
        
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        nav2.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass", withConfiguration: symbolConfig))
        nav3.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "plus"), selectedImage: UIImage(systemName: "plus", withConfiguration: symbolConfig))
        nav4.tabBarItem = UITabBarItem(title: "Wallet", image: UIImage(systemName: "bitcoinsign.square"), selectedImage: UIImage(systemName: "bitcoinsign.square.fill"))
        nav5.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: false)
    }

}
