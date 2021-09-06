//
//  UserListViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 7/1/21.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        return tableView
    }()
    
    enum ListType: String {
        case followers
        case following
    }
    
    private let noUsersFollowersLabel: UILabel = {
        let label = UILabel()
        label.text = "You have no followers yet."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let noUsersFollowingLabel: UILabel = {
        let label = UILabel()
        label.text = "You are not following anyone yet."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    let user: User
    let type: ListType
    public var users = [String]()
    
    // MARK: - Init
    
    init(type: ListType, user: User) {
        self.type = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        switch type {
        case .followers: title = "Followers"
        case .following: title = "Following"
        }
        if users.isEmpty {
            view.addSubview(noUsersFollowersLabel)
            noUsersFollowersLabel.sizeToFit()
        }
        else {
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.superview == view {
            tableView.frame = view.bounds
        }
        else {
            noUsersFollowersLabel.center = view.center
        }
    }
    
    // TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        cell.selectionStyle = .none
        cell.textLabel?.text = users[indexPath.row].lowercased()
        return cell
    }
    
}
