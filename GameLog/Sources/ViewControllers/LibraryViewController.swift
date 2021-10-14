//
//  LibraryViewController.swift
//  GameLog
//
//  Created by duckbok on 2021/09/06.
//

import UIKit

final class LibraryViewController: GLMainViewController {

    private enum Style {
        enum ColletionView {
            enum Header {
                static let height: CGFloat = 44
            }

            enum Item {
                static let count: Int = 3
            }

            enum Section {
                static let contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                static let interGroupSpacing: CGFloat = 16
            }
        }
    }

    override var tabBarInfo: GLTabBarController.TabBarInfo {
        return ("라이브러리", "square.grid.3x2.fill")
    }

    private var libraryViewModel = LibraryViewModel()

    // MARK: - View

    private lazy var libraryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(LibraryCell.self, forCellWithReuseIdentifier: LibraryCell.reuseIdentifier)
        collectionView.register(LibraryHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: LibraryHeaderView.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        libraryViewModel.loadLibrary(page: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Configure

    private func collectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(0.2))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: Style.ColletionView.Item.count)
            group.interItemSpacing = .fixed(Style.ColletionView.Section.interGroupSpacing)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = Style.ColletionView.Section.contentInsets
            section.interGroupSpacing = Style.ColletionView.Section.interGroupSpacing

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(Style.ColletionView.Header.height)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            sectionHeader.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [sectionHeader]

            return section
        })
    }

    private func configureCollectionView() {
        view.addSubview(libraryCollectionView)
        NSLayoutConstraint.activate([
            libraryCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            libraryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            libraryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            libraryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureDataSource() {
        libraryViewModel.dataSource =
            Global.LibraryDataSource(collectionView: libraryCollectionView) { collectionView, indexPath, game in
                let libraryCell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCell.reuseIdentifier,
                                                              for: indexPath) as? LibraryCell
                libraryCell?.game = game

                return libraryCell
            }

        libraryViewModel.dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }

            let library = self?.libraryViewModel.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            let libraryHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LibraryHeaderView.reuseIdentifier,
                for: indexPath) as? LibraryHeaderView
            libraryHeaderView?.sortingMethodButton.setTitle(library?.sorting?.method.name, for: .normal)
            libraryHeaderView?.sortingOrderButton.setImage(library?.sorting?.order.sign, for: .normal)

            return libraryHeaderView
        }
    }
}

// MARK: - UICollectionViewDelegate

extension LibraryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let libraryCell = collectionView.cellForItem(at: indexPath) as? LibraryCell,
              let game = libraryCell.game,
              let coverImage = libraryCell.coverImageView.image else { return }
        let gameViewController = GameViewController(gameID: game.gameID, name: game.name, cover: coverImage)

        navigationController?.pushViewController(gameViewController, animated: true)
    }
}
