//
//  DiscoverViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 6/30/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search..."
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()
    
    private var sections = [DiscoverSection]()
    
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        DiscoverManager.shared.delegate = self
        view.backgroundColor = .systemBackground
        configureModels()
        setUpSearchBar()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func setUpSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureModels() {
        var cells = [DiscoverCell]()
        for _ in 0...100 {
            let cell = DiscoverCell.banner(
                viewModel: DiscoverBannerViewModel(
                    image: UIImage(named: "test"),
                    title: "Foo",
                    handler: {
                        
                    }
                )
            )
            cells.append(cell)
        }
        // Banner
        sections.append(
            DiscoverSection(
                type: .banners,
                cells: DiscoverManager.shared.getDiscoverBanners().compactMap({
                    return DiscoverCell.banner(viewModel: $0)
                })
            )
        )
        
        // Trending Posts
        sections.append(
            DiscoverSection(
                type: .trendingPosts,
                cells: DiscoverManager.shared.getDiscoverTrendingPosts().compactMap({
                    return DiscoverCell.post(viewModel: $0)
                })
            )
        )
        
        // Users
        sections.append(
            DiscoverSection(
                type: .users,
                cells: DiscoverManager.shared.getDiscoverCreators().compactMap({
                    return DiscoverCell.user(viewModel: $0)
                })
            )
        )
        
        // Trending Hashtags
        sections.append(
            DiscoverSection(
                type: .trendingHashtags,
                cells: DiscoverManager.shared.getDiscoverHashtags().compactMap({
                    return DiscoverCell.hashtag(viewModel: $0)
                })
            )
        )
        
        
        // popular
        sections.append(
            DiscoverSection(
                type: .popular,
                cells: DiscoverManager.shared.getDiscoverPopularPosts().compactMap({
                    return DiscoverCell.post(viewModel: $0)
                })
            )
        )
        
        
        // new
        sections.append(
            DiscoverSection(
                type: .new,
                cells: DiscoverManager.shared.getDiscoverRecentPosts().compactMap({
                    return DiscoverCell.post(viewModel: $0)
                })
            )
        )
        
        
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.register(
            DiscoverBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverBannerCollectionViewCell.identifier
        )
        collectionView.register(
            DiscoverPostCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverPostCollectionViewCell.identifier
        )
        collectionView.register(
            DiscoverUserCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverUserCollectionViewCell.identifier
        )
        collectionView.register(
            DiscoverHashtagCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverHashtagCollectionViewCell.identifier
        )
        
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DiscoverBannerCollectionViewCell.identifier,
                    for: indexPath
            ) as? DiscoverBannerCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DiscoverPostCollectionViewCell.identifier,
                    for: indexPath
            ) as? DiscoverPostCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DiscoverHashtagCollectionViewCell.identifier,
                    for: indexPath
            ) as? DiscoverHashtagCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DiscoverUserCollectionViewCell.identifier,
                    for: indexPath
            ) as? DiscoverUserCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
            viewModel.handler()
        case .post(let viewModel):
            viewModel.handler()
        case .hashtag(let viewModel):
            viewModel.handler()
        case .user(let viewModel):
            viewModel.handler()
        }
    }
    
}

extension DiscoverViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(didTapCancel)
        )
    }
    
    @objc func didTapCancel() {
        navigationItem.rightBarButtonItem = nil
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = nil
        searchBar.resignFirstResponder()
    }
}

// MARK: - Section Layouts

extension DiscoverViewController {
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        
        switch sectionType {
        case .banners:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.90),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
        case .users:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            // Return
            return sectionLayout
        case .trendingHashtags:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitems: [item]
            )
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            
            // Return
            return sectionLayout
        case .trendingPosts, .new, .recommended:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(300)
                ),
                subitem: item,
                count: 2
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(300)
                ),
                subitems: [verticalGroup]
            )
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            // Return
            return sectionLayout
        case .popular:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            // Return
            return sectionLayout
        }
    }
}

extension DiscoverViewController: DiscoverManagerDelegate {
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapHashtag(_ hashtag: String) {
        searchBar.text = hashtag
        searchBar.becomeFirstResponder()
    }
}

extension DiscoverViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension DiscoverViewController: PostViewControllerDelegate {
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
    
    @objc func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DiscoverViewController: CommentsViewControllerDelegate {
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
