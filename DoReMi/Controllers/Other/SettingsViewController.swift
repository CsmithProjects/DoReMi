//
//  SettingsViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 7/1/21.
//

import Appirater
import SafariServices
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        table.register(
            SwitchTableViewCell.self,
            forCellReuseIdentifier: SwitchTableViewCell.identifier
        )
        return table
    }()
    
    var sections = [SettingsSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [
            SettingsSection(
                title: "Preferences",
                options: [
                    SettingsOption(title: "Save Videos", handler: { })
                ]
            ),
            SettingsSection(
                title: "Enjoying the app?",
                options: [
                    SettingsOption(title: "Rate App", handler: {
                        DispatchQueue.main.async {
                            Appirater.tryToShowPrompt()
                            //UIApplication.shared.open(URL(string: "")!, options: [:], completionHandler: nil)
                        }
                    }),
                    SettingsOption(title: "Share App", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "my app to url direct download") else {
                                return
                            }
                            let vc = UIActivityViewController(
                                activityItems: [url],
                                applicationActivities: []
                            )
                            self?.present(vc, animated: true, completion: nil)
                        }
                    })
                ]
            ),
            SettingsSection(
                title: "Information",
                options: [
                    SettingsOption(title: "Terms of Service", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "") else {
                                return
                            }
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true)
                        }
                    }),
                    SettingsOption(title: "Privacy Policy", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "") else {
                                return
                            }
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true)
                        }
                    })
                ]
            )
        ]
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        createFooter()
    }
    
    func createFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 100))
        let button = UIButton(frame: CGRect(x: (view.width - 200)/2, y: 25, width: 200, height: 50))
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        footer.addSubview(button)
        tableView.tableFooterView = footer
    }
    
    @objc func didTapSignOut() {
        let actionSheet = UIAlertController(
            title: "Sign Out",
            message: "Would you like to sign out?",
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            DispatchQueue.main.async {
                AuthManager.shared.signOut { [weak self] success in
                    if success{
                        UserDefaults.standard.setValue(nil, forKey: "username")
                        UserDefaults.standard.setValue(nil, forKey: "profile_picture_url")
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.tabBarController?.selectedIndex = 0
                    }
                    else {
                        let alert = UIAlertController(
                            title: "Whoops",
                            message: "Something went wrong when signing out. Please try again",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        
        //REDO: Make it a switch statment like in Discover controller
        if model.title == "Save Videos" {
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SwitchTableViewCell.identifier,
                    for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: SwitchCellViewModel(title: model.title, isOn: UserDefaults.standard.bool(forKey: "save_video")))
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

extension SettingsViewController: SwitchTableViewCellDelegate {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool) {
        UserDefaults.standard.setValue(isOn, forKey: "save_video")
    }
}
