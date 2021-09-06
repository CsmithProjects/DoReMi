//
//  DiscoverViewController.swift
//  DoReMi
//
//  Created by Conor Smith on 6/30/21.
//

import UIKit

protocol DiscoverViewControllerDelegate {}

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
    
    private var isLoading = true
    
    private var selectedIndexPath: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        DiscoverManager.shared.delegate = self
        view.backgroundColor = .systemBackground
        setUpSearchBar()
        configureLoadingModels()
        setUpCollectionView()
        collectionView?.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.configureModels()
            self.setUpCollectionView()
            self.collectionView?.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func setUpSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    // MARK: - Loading Screen
    
    func configureLoadingModels() {
        var cells = [DiscoverCell]()
        let cell = DiscoverCell.banner(
            viewModel: DiscoverBannerViewModel(
                image: nil,
                title: "",
                handler: {
                    //empty
                }
            )
        )
        cells.append(cell)
        
        // Banner
        sections.append(
            DiscoverSection(
                type: .banners,
                cells: cells
            )
        )
        
        cells = [DiscoverCell]()
        for _ in 0...7 {
            let cell = DiscoverCell.post(
                viewModel: DiscoverPostViewModel(
                    thumbnailImage: nil,
                    caption: "",
                    handler: {
                        //empty
                    }
                )
            )
            cells.append(cell)
        }
        
        // Trending Posts
        sections.append(
            DiscoverSection(
                type: .trendingPosts,
                cells: cells
            )
        )
        
        cells = [DiscoverCell]()
        for _ in 0...2 {
            let cell = DiscoverCell.user(
                viewModel: DiscoverUserViewModel(
                    profilePicture: nil,
                    username: "",
                    followerCount: 0,
                    handler: {
                        //empty
                    }
                )
            )
            cells.append(cell)
        }
        
        // Users
        sections.append(
            DiscoverSection(
                type: .users,
                cells: cells
            )
        )

    }
    
    // MARK: - Loading Data
    
    private func configureModels() {
        isLoading = false
        sections.removeAll() //simple way to remove everything in collectionView essentially

        
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
            DiscoverBannerLoadingCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverBannerLoadingCollectionViewCell.identifier
        )
        collectionView.register(
            DiscoverPostCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverPostCollectionViewCell.identifier
        )
        collectionView.register(
            DiscoverPostLoadingCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverPostLoadingCollectionViewCell.identifier
        )
        collectionView.register(
            DiscoverUserCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverUserCollectionViewCell.identifier
        )
        collectionView.register(
            DiscoverUserLoadingCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverUserLoadingCollectionViewCell.identifier
        )
        collectionView.register(
            DiscoverHashtagCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverHashtagCollectionViewCell.identifier
        )
        collectionView.register(
            DiscoverHashtagLoadingCollectionViewCell.self,
            forCellWithReuseIdentifier: DiscoverHashtagLoadingCollectionViewCell.identifier
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
            if (isLoading) {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DiscoverBannerLoadingCollectionViewCell.identifier,
                        for: indexPath
                ) as? DiscoverBannerLoadingCollectionViewCell else {
                    return collectionView.dequeueReusableCell(
                        withReuseIdentifier: "cell",
                        for: indexPath
                    )
                }
                cell.configure(with: viewModel)
                return cell
            }
            else {
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
            }
        case .post(let viewModel):
            if (isLoading) {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DiscoverPostLoadingCollectionViewCell.identifier,
                        for: indexPath
                ) as? DiscoverPostLoadingCollectionViewCell else {
                    return collectionView.dequeueReusableCell(
                        withReuseIdentifier: "cell",
                        for: indexPath
                    )
                }
                cell.configure(with: viewModel)
                return cell
            }
            else {
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
            }
        case .hashtag(let viewModel):
            if (isLoading) {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DiscoverHashtagLoadingCollectionViewCell.identifier,
                        for: indexPath
                ) as? DiscoverHashtagLoadingCollectionViewCell else {
                    return collectionView.dequeueReusableCell(
                        withReuseIdentifier: "cell",
                        for: indexPath
                    )
                }
                cell.configure(with: viewModel)
                return cell
            } else {
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
            }
        case .user(let viewModel):
            if (isLoading) {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DiscoverUserLoadingCollectionViewCell.identifier,
                        for: indexPath
                ) as? DiscoverUserLoadingCollectionViewCell else {
                    return collectionView.dequeueReusableCell(
                        withReuseIdentifier: "cell",
                        for: indexPath
                    )
                }
                cell.configure(with: viewModel)
                return cell
            } else {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = sections[indexPath.section].cells[indexPath.row]
        
        self.selectedIndexPath = indexPath
 
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
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.00),
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
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(141),
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
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 6, trailing: 4)
            
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
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(350)
                ),
                subitem: item,
                count: 2
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(350)
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
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 4, bottom: 4, trailing: 4)
            
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
    func didTapCommentsButton(_ vc: UIViewController) {
        navigationController?.topViewController?.view.isUserInteractionEnabled = false
        navigationController?.topViewController?.addChild(vc)
        vc.didMove(toParent: navigationController?.topViewController)
        navigationController?.topViewController?.view.addSubview(vc.view)
        let frame: CGRect = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.76)
        vc.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
        } completion: { done in
            if done {
                self.navigationController?.topViewController?.view.isUserInteractionEnabled = true
            }
        }
    }
    
//    func presentViewController(_ vc: UIViewController) {
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .fullScreen
//        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBack))
//        //vc.modalPresentationStyle = .currentContext
//        navigationController?.present(vc, animated: true)
//    }
    
    func pushViewController(_ vc: UIViewController, _ isPostVC: Bool) {
        if isPostVC == true {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackToOtherVC))
            navigationController?.navigationBar.tintColor = .white
        }
        else {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackToPostVC))
            navigationController?.navigationBar.tintColor = .label
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapBackToOtherVC() {
        navigationController?.navigationBar.tintColor = .label
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapBackToPostVC() {
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapHashtag(_ hashtag: String) {
        searchBar.text = hashtag
        searchBar.becomeFirstResponder()
    }
}

extension DiscoverViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
