//
//  TabBarViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 6/30/21.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var signInPresented = false
    
    private var currentIndex = 0 //needed to keep current tab bar item index before changing it
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
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
        
        var urlString: String?
        if let cachedUrlString = UserDefaults.standard.string(forKey: "profile_picture_url") {
            urlString = cachedUrlString
        }
        
        let profile = ProfileViewController(
            user: User(
                username: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? "Me",
                profilePictureURL: URL(string: urlString ?? ""),
                identifier: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
            )
        )
        
        home.title = "Home"
        wallet.title = "Wallet"
        //profile.title = "Profile"
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: discover)
        let nav3 = UINavigationController(rootViewController: create)
        let nav4 = UINavigationController(rootViewController: wallet)
        let nav5 = UINavigationController(rootViewController: profile)
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()

        nav2.navigationBar.backgroundColor = .clear
        nav2.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav2.navigationBar.shadowImage = UIImage()
        
        nav3.navigationBar.backgroundColor = .clear
        nav3.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav3.navigationBar.shadowImage = UIImage()
        nav3.navigationBar.tintColor = .white
        
        nav4.navigationBar.backgroundColor = .clear
        nav4.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav4.navigationBar.shadowImage = UIImage()
        
        nav5.navigationBar.backgroundColor = .clear
        nav5.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav5.navigationBar.shadowImage = UIImage()
        
        //nav4.navigationBar.tintColor = .label -- may add this not sure yet
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        nav2.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass", withConfiguration: symbolConfig))
        nav3.tabBarItem = UITabBarItem()
        nav4.tabBarItem = UITabBarItem(title: "Wallet", image: UIImage(systemName: "bitcoinsign.square"), selectedImage: UIImage(systemName: "bitcoinsign.square.fill"))
        nav5.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        //preset bar colors
        self.tabBar.tintColor = .white
        self.tabBar.barTintColor = .black
        self.tabBar.isTranslucent = false
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: false)
        
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = self.tabBar.items?.firstIndex(of: item) else {
            return
        }
        guard let subView = tabBar.subviews[index+1].subviews.first as? UIImageView else {
            return
        }
        if (index != currentIndex) {
            if item == (self.tabBar.items!)[0]{
                AnimationsManager.shared.performSpringAnimation(imgView: subView)
            }
            else if item == (self.tabBar.items!)[1]{
                AnimationsManager.shared.performReverseSpringAnimation(imgView: subView)
            }
            else if item == (self.tabBar.items!)[2]{
               //Putting my created button here. maybe
            }
            else if item == (self.tabBar.items!)[3]{
                AnimationsManager.shared.performClockwiseAnimation(imgView: subView)
            }
            else if item == (self.tabBar.items!)[4]{
                AnimationsManager.shared.performSpringAnimation(imgView: subView)
            }
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (tabBarController.selectedIndex == 0) {
            self.tabBar.tintColor = .white
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self.tabBar.barTintColor = .black
                self.tabBar.isTranslucent = false
                self.tabBar.layoutIfNeeded()
                self.currentIndex = tabBarController.selectedIndex
            }
        }
        else {
            self.tabBar.tintColor = .label
            self.tabBar.isTranslucent = true
            self.tabBar.barTintColor = .systemBackground
            self.currentIndex = tabBarController.selectedIndex
        }
    }
}
