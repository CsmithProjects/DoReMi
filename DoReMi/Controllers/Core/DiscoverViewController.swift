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
    
    func configureModels() {
        var cells = [DiscoverCell]()
        for _ in 0...100 {
            let cell = DiscoverCell.banner(
                viewModel: DiscoverBannerViewModel(
                    image: nil,
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
                cells: cells
            )
        )
        
        var posts = [DiscoverCell]()
        for _ in 0...40 {
            posts.append(
                .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                    
                }))
            )
        }
        // Trending Posts
        sections.append(
            DiscoverSection(
                type: .trendingPosts,
                cells: posts
            )
        )
        
        // Users
        sections.append(
            DiscoverSection(
                type: .users,
                cells: [
                    .user(viewModel: DiscoverUserViewModel(profilePictureURL: nil, username: "", followerCount: 0, handler: {
                        
                    })),
                    .user(viewModel: DiscoverUserViewModel(profilePictureURL: nil, username: "", followerCount: 0, handler: {
                        
                    })),
                    .user(viewModel: DiscoverUserViewModel(profilePictureURL: nil, username: "", followerCount: 0, handler: {
                        
                    })),
                    .user(viewModel: DiscoverUserViewModel(profilePictureURL: nil, username: "", followerCount: 0, handler: {
                        
                    }))
                ]
            )
        )
        
        // Trending Hashtags
        sections.append(
            DiscoverSection(
                type: .trendingHashtags,
                cells: [
                    .hashtag(viewModel: DiscoverHashtagViewModel(icon: nil, text: "#foryou", count: 1, handler: {
                        
                    })),
                    .hashtag(viewModel: DiscoverHashtagViewModel(icon: nil, text: "#foryou", count: 1, handler: {
                        
                    })),
                    .hashtag(viewModel: DiscoverHashtagViewModel(icon: nil, text: "#foryou", count: 1, handler: {
                        
                    }))
                ]
            )
        )
        
        // Recommmended
        sections.append(
            DiscoverSection(
                type: .recommended,
                cells: [
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    })),
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    })),
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    })),
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    }))
                ]
            )
        )
        
        
        // popular
        sections.append(
            DiscoverSection(
                type: .popular,
                cells: [
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    })),
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    })),
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    })),
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    }))
                ]
            )
        )
        
        
        // new
        sections.append(
            DiscoverSection(
                type: .new,
                cells: [
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    })),
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    })),
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    })),
                    .post(viewModel: DiscoverPostViewModel(thumbnailImage: nil, caption: "", handler: {
                        
                    }))
                ]
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
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
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
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
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
                    heightDimension: .absolute(240)
                ),
                subitem: item,
                count: 2
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(240)
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
            break
        case .post(let viewModel):
            break
        case .hashtag(let viewModel):
            break
        case .user(let viewModel):
            break
        }
        
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )
        cell.backgroundColor = .red
        
        return cell
    }
    
    
}

extension DiscoverViewController: UISearchBarDelegate {
    
}
