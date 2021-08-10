//
//  ProfileViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 6/30/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let user: User
    
    private let notificationsButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "bell"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
        button.tintColor = .label
        button.layer.masksToBounds = true
        return button
    }()
    
    private let messagesButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "paperplane"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 27, height: 25)
        button.tintColor = .label
        button.layer.masksToBounds = true
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 27, height: 25)
        button.tintColor = .label
        button.layer.masksToBounds = true
        return button
    }()
    
    private let optionsButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 27, height: 8)
        button.tintColor = .label
        button.layer.masksToBounds = true
        return button
    }()

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        setUpBarButtons()
        
    }
    
    private func setUpBarButtons() {
        let vc = self.navigationController?.viewControllers.first
        if vc == self.navigationController?.visibleViewController {
            //is first navigation controller in list and always users
            
            notificationsButton.addTarget(self, action: #selector(didTapNotifications), for: .touchUpInside)
            messagesButton.addTarget(self, action: #selector(didTapMessages), for: .touchUpInside)
            settingsButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
            
            let notificationsBarButton = UIBarButtonItem(customView: notificationsButton)
            let messagesBarButton = UIBarButtonItem(customView: messagesButton)
            let settingsBarButton = UIBarButtonItem(customView: settingsButton)
            let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            space.width = view.width / 20
            
            self.navigationItem.rightBarButtonItems = [
                settingsBarButton,
                space,
                messagesBarButton,
                space,
                notificationsBarButton
            ]
        } else {
            //is not first navigation controller and could be or not be users
            //**Need to add if () user is themselves
            
            notificationsButton.addTarget(self, action: #selector(didTapNotifications), for: .touchUpInside)
            //optionsButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
            
            let notificationsBarButton = UIBarButtonItem(customView: notificationsButton)
            let optionsBarButton = UIBarButtonItem(customView: optionsButton)
            let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            space.width = view.width / 20
            
            self.navigationItem.rightBarButtonItems = [
                optionsBarButton,
                space,
                notificationsBarButton
            ]
        }
    }
    
    @objc func didTapNotifications() {
        let vc = NotificationsViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBack))
        navigationController?.navigationBar.barTintColor = .label
        self.show(vc, sender: self)
    }
    
    @objc func didTapMessages() {
        
    }
    
    @objc func didTapSettings() {
        
    }
    
    @objc func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
