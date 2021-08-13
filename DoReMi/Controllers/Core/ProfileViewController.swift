//
//  ProfileViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 6/30/21.
//

import ProgressHUD
import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var isCurrentUserProfile: Bool {
        if let username = UserDefaults.standard.string(forKey: "username") {
            return user.username.lowercased() != username.lowercased()
        }
        return true
    }
    
    enum PicturePickerType {
        case camera
        case photoLibrary
    }
    
    var user: User
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator = false
        collection.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier
        )
        collection.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        return collection
    }()
    
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
    
    private var posts = [PostModel]()

    // MARK: - Init
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        setUpProfile()
        fetchPosts()
    }
    
    func fetchPosts() {
        DatabaseManager.shared.getPosts(for: user) { [weak self] postModels in
            DispatchQueue.main.async {
                self?.posts = postModels
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setUpProfile() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        let vc = self.navigationController?.viewControllers.first
        let username = UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
        if vc == self.navigationController?.visibleViewController && title != username {
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
        } else if (vc != self.navigationController?.visibleViewController && title != username) {
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
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let username = UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
        if (username != title) {
            collectionView.frame = view.bounds
        }
    }
    
    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let postModel = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // open post
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.width - 12) / 3
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath
              ) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.delegate = self
        let viewModel = ProfileHeaderViewModel(
            avatarImageURL: user.profilePictureURL,
            followerCount: 120,
            followingCount: 200,
            isFollowing: isCurrentUserProfile ? nil: false
        )
        header.configure(with: viewModel)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
}

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        if self.user.username == currentUsername {
            // Edit Profile
        }
        else {
            // Follow or Unfollow current users profile that we are viewing
        }
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: ProfileHeaderViewModel) {
        
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarFor viewModel: ProfileHeaderViewModel) {
        guard isCurrentUserProfile else {
            return
        }
        let actionSheet = UIAlertController(title: "Profile Picture", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .camera)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .photoLibrary)
            }
        }))
        present(actionSheet, animated: true)
    }
    
    func presentProfilePicturePicker(type: PicturePickerType) {
        let picker = UIImagePickerController()
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        ProgressHUD.show("Uploading")
        StorageManager.shared.uploadProfilePicture(with: image) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let downloadURL):
                    UserDefaults.standard.setValue(downloadURL.absoluteString, forKey: "profile_picture_url")
                    strongSelf.user = User(
                        username: strongSelf.user.username,
                        profilePictureURL: downloadURL,
                        identifier: strongSelf.user.username
                    )
                    ProgressHUD.showSuccess("Updated!")
                    strongSelf.collectionView.reloadData()
                case .failure:
                    ProgressHUD.showError("Failed to update profile picture.")
                }
            }
        }
    }
}
