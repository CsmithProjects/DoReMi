//
//  NotificationsViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 7/29/21.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let noNotificationsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "No Notifications"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        table.register(
            NotificationsUserFollowTableViewCell.self,
            forCellReuseIdentifier: NotificationsUserFollowTableViewCell.identifier
        )
        table.register(
            NotificationsPostCommentTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostCommentTableViewCell.identifier
        )
        table.register(
            NotificationsPostLikeTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostLikeTableViewCell.identifier
        )
        return table
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()
    
    var notifications = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notifications"
        view.addSubview(noNotificationsLabel)
        view.addSubview(tableView)
        view.addSubview(spinner)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didCallRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = control
        
        fetchNotifications()
    }
    
    @objc func didCallRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.notifications = notifications
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationsLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noNotificationsLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    func fetchNotifications() {
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }
    
    func updateUI() {
        if notifications.isEmpty {
            noNotificationsLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noNotificationsLabel.isHidden = true
            tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]
        
        switch model.type {
        case .postLike(let postName):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: NotificationsPostLikeTableViewCell.identifier,
                    for: indexPath
            ) as? NotificationsPostLikeTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: NotificationsUserFollowTableViewCell.identifier,
                    for: indexPath
            ) as? NotificationsUserFollowTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self
            cell.configure(with: username, model: model)
            return cell
        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: NotificationsPostCommentTableViewCell.identifier,
                    for: indexPath
            ) as? NotificationsPostCommentTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let model = notifications[indexPath.row]
        model.isHidden = true
        
        DatabaseManager.shared.markNotificationAsHidden(notificationID: model.identifier) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.notifications = self?.notifications.filter({ $0.isHidden == false}) ?? []
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension NotificationsViewController: NotificationsUserFollowTableViewCellDelegate {
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapFollowFor username: String) {
        DatabaseManager.shared.follow(username: username) { success in
            if !success {
                print("Success went wrong")
            }
        }
    }
    
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapAvatarFor username: String) {
        let vc = ProfileViewController(
            user:
                User(
                    username: username,
                    profilePictureURL: nil,
                    identifier: "123"
                )
        )
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotificationsViewController: NotificationsPostLikeTableViewCellDelegate {
    func notificationsPostLikeTableViewCell(_ cell: NotificationsPostLikeTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationsViewController: NotificationsPostCommentTableViewCellDelegate {
    func notificationsPostCommentTableViewCell(_ cell: NotificationsPostCommentTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationsViewController {
    func openPost(with identifier: String) {
        // resolve the post model from the db
        let vc = PostViewController(model: PostModel(identifier: identifier, user: User(
            username: "kanyewest",
            profilePictureURL: nil,
            identifier: UUID().uuidString
        )))
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBack))
        navigationController?.navigationBar.tintColor = .white
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapBack() {
        navigationController?.navigationBar.tintColor = .label
        self.navigationController?.popViewController(animated: true)
    }
    
}
