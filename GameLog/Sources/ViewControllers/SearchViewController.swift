//
//  SearchViewController.swift
//  GameLog
//
//  Created by duckbok on 2021/09/06.
//

import UIKit

final class SearchViewController: GLMainViewController {

    private enum Style {
        enum SearchBar {
            static let cancelButton: String = "취소"
            static let placeHolder: String = "게임 이름"
        }

        enum ColletionView {
            enum Item {
                static let spacing: CGFloat = 8
            }

            enum Section {
                static let contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
            }
        }
    }

    override var tabBarInfo: GLTabBarController.TabBarInfo {
        return ("검색", "magnifyingglass")
    }

    private let searchViewModel = SearchViewModel()

    // MARK: - View

    private let loadingIndicator = UIActivityIndicatorView(style: .large, color: Global.Style.mainColor)

    private lazy var resultCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
    }

    // MARK: - Configure

    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = Style.SearchBar.placeHolder
        searchController.searchBar.setValue(Style.SearchBar.cancelButton, forKey: "cancelButtonText")
        navigationItem.searchController = searchController
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalWidth(0.3))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = Style.ColletionView.Section.contentInsets
            section.interGroupSpacing = Style.ColletionView.Item.spacing

            return section
        })
    }

    private func configureCollectionView() {
        view.addSubview(resultCollectionView)
        NSLayoutConstraint.activate([
            resultCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            resultCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            resultCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureDataSource() {
        searchViewModel.dataSource =
            Global.SearchDataSource(collectionView: resultCollectionView) { collectionView, indexPath, game in
                let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier,
                                                                    for: indexPath) as? SearchCell
                searchCell?.game = game

                return searchCell
            }
    }

    // MARK: - Method
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchCell = collectionView.cellForItem(at: indexPath) as? SearchCell,
              let game = searchCell.game,
              let coverImage = searchCell.coverImageView.image else { return }
        let gameViewController = GameViewController(gameID: game.id, name: game.name, cover: coverImage)

        navigationController?.pushViewController(gameViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.fetchGames(by: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.fetchGames(by: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.fetchGames(by: searchBar.text)
    }
}
