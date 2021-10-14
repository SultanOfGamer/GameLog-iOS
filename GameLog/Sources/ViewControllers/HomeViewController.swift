//
//  HomeViewController.swift
//  GameLog
//
//  Created by duckbok on 2021/08/23.
//

import UIKit

final class HomeViewController: GLMainViewController {

    private enum Style {
        enum ColletionView {
            enum Header {
                static let height: CGFloat = 44
            }

            enum Item {
                static let height: CGFloat = 100
                static let count: Int = 4
            }

            enum Section {
                static let contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                static let interGroupSpacing: CGFloat = 10
            }
        }
    }

    override var tabBarInfo: GLTabBarController.TabBarInfo {
        return ("홈", "house.fill")
    }

    private var homeViewModel = HomeViewModel()

    // MARK: - View

    private let loadingIndicator = UIActivityIndicatorView(style: .large, color: Global.Style.mainColor)

    private lazy var homeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()

        view.addSubview(loadingIndicator)
        loadingIndicator.startLoading(to: homeCollectionView)
        homeViewModel.loadSections()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Configure

    private func collectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.fractionalHeight(1)
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(0.9),
                heightDimension: NSCollectionLayoutDimension.absolute(Style.ColletionView.Item.height)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: Style.ColletionView.Item.count)
            group.interItemSpacing = .fixed(8)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = Style.ColletionView.Section.contentInsets
            section.interGroupSpacing = Style.ColletionView.Section.interGroupSpacing
            section.orthogonalScrollingBehavior = .continuous

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(Style.ColletionView.Header.height)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
    }

    private func configureCollectionView() {
        view.addSubview(homeCollectionView)
        NSLayoutConstraint.activate([
            homeCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            homeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureDataSource() {
        homeViewModel.dataSource =
            Global.GameDataSource(collectionView: homeCollectionView) { collectionView, indexPath, game in
                let gameCell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseIdentifier,
                                                              for: indexPath) as? GameCell
                gameCell?.game = game

                return gameCell
            }

        homeViewModel.dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            self?.loadingIndicator.stopLoading(to: collectionView)

            let section = self?.homeViewModel.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath) as? SectionHeaderView
            supplementaryView?.titleLabel.text = section?.type

            return supplementaryView
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let gameCell = collectionView.cellForItem(at: indexPath) as? GameCell,
              let game = gameCell.game,
              let coverImage = gameCell.coverImageView.image else { return }
        let gameViewController = GameViewController(gameID: game.id, name: game.name, cover: coverImage)

        navigationController?.pushViewController(gameViewController, animated: true)
    }
}
