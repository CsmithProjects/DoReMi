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
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCollectionViewCell.identifier
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
    
    //For desired effect I could not put images in collectionReusableView
    
    private let avatarImageView: AvatarImageView = {
        let imageView = AvatarImageView(image: UIImage(named: "Test"))
        return imageView
    }()
    
    private let coverPhotoImageView: CoverPhotoImageView = {
        let imageView = CoverPhotoImageView(image: UIImage(named: "splashBackground"))
        return imageView
    }()
    
    private var posts = [PostModel]()
    
    private var followers = [String]()
    private var following = [String]()
    private var isFollower: Bool = false
    
    //private var coverPhoto: UIImageView?
    
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
        fetchProfileImages()
        //fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Profile"
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func fetchProfileImages() {
        if let avatarURL = self.user.profilePictureURL {
            avatarImageView.sd_setImage(with: avatarURL, completed: nil)
        }
        else {
            avatarImageView.image = UIImage(named: "Test")
        }
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
        
        collectionView.addSubview(coverPhotoImageView)
        collectionView.addSubview(avatarImageView)
        
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
        navigationController?.navigationBar.tintColor = .label
        self.show(vc, sender: self)
    }
    
    @objc func didTapMessages() {
        
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBack))
        navigationController?.navigationBar.tintColor = .label
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let username = UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
        
        let avatarSize: CGFloat = 130
        avatarImageView.frame = CGRect(x: (view.width - avatarSize)/2, y: 200 - (avatarSize/3), width: avatarSize, height: avatarSize)
        avatarImageView.layer.cornerRadius = avatarImageView.height/2
        
        if (username != title) {
            collectionView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        }
        coverPhotoImageView.frame = CGRect(x: 0, y: 0, width: view.width, height: 200)
    }
    
    // MARK: - CollectionView
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let postModel = posts[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCollectionViewCell.identifier,
            for: indexPath
        ) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        //cell.configure(with: postModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // open post
        let post = posts[indexPath.row]
        let vc = PostViewController(model: post)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.width - 2) / 3
        return CGSize(width: width, height: width * 1.325)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
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
        //coverPhoto = header.coverPhotoImageView
        //coverPhoto?.image = UIImage(named: "splashBackground")
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        DatabaseManager.shared.getRelationships(for: user, type: .followers) { [weak self] followers in
            defer {
                group.leave()
            }
            self?.followers = followers
        }
        
        DatabaseManager.shared.getRelationships(for: user, type: .following) { [weak self] following in
            defer {
                group.leave()
            }
            self?.following = following
        }
        
        DatabaseManager.shared.isValidRelationship(for: user, type: .followers) { [weak self] isFollower in
            defer {
                group.leave()
            }
            self?.isFollower = isFollower
        }
        
        group.notify(queue: .main) {
            let viewModel = ProfileHeaderViewModel(
                avatarImageURL: self.user.profilePictureURL,
                coverPhotoImageURL: self.user.coverPictureURL,
                followerCount: self.followers.count,
                followingCount: self.following.count,
                isFollowing: self.isCurrentUserProfile ? nil: self.isFollower
            )
            header.configure(with: viewModel)
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 500)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = 200 - scrollView.contentOffset.y
        //let h = max(60, y)
        
        let rect = CGRect(x: 0, y: scrollView.contentOffset.y, width: view.bounds.width, height: y)
        coverPhotoImageView.frame = rect
        
        //let alpha = (scrollView.contentOffset.y / 88) + 1
        //let translate = (scrollView.contentOffset.y / 2) + 1
        //let avatarSize: CGFloat = 130
        //print(translate)
        
        //avatarImageView.frame = CGRect(x: (view.width - avatarSize)/2, y: 200 - (avatarSize/3) - translate, width: avatarSize, height: avatarSize)
    }
}

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {
        
        if isCurrentUserProfile {
            // Edit Profile
            let vc = EditProfileViewController()
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true)
        }
        else {
            // Follow or Unfollow current users profile that we are viewing
            if self.isFollower {
                DatabaseManager.shared.updateRelationship(for: user, follow: false) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isFollower = false
                            self?.collectionView.reloadData()
                        }
                    }
                    else {
                        
                    }
                }
            }
            else {
                DatabaseManager.shared.updateRelationship(for: user, follow: true) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isFollower = true
                            self?.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: ProfileHeaderViewModel) {
        let vc = UserListViewController(type: .followers, user: user)
        vc.users = followers
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        let vc = UserListViewController(type: .following, user: user)
        vc.users = following
        navigationController?.pushViewController(vc, animated: true)
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
                        coverPictureURL: strongSelf.user.coverPictureURL,
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

extension ProfileViewController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        let vc = CommentsViewController(post: post)
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame: CGRect = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.76)
        vc.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
        }
    }
    
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        let user = post.user
        let vc = ProfileViewController(user: user)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBack))
        navigationController?.navigationBar.tintColor = .label
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: CommentsViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentsViewController) {
        //close comment with animation
        let frame = viewController.view.frame
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame = CGRect(x: 0, y: self.view.height, width: frame.width, height: frame.height)
        } completion: { done in
            if done {
                DispatchQueue.main.async {
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                }
            }
        }
    }
}
