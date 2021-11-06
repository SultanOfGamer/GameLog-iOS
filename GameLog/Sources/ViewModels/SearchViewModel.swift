//
//  SearchViewModel.swift
//  GameLog
//
//  Created by duckbok on 2021/10/20.
//

import Foundation

final class SearchViewModel {

    var dataSource: Global.SearchDataSource?

    private let searchService = SearchService()

    private var search: Search? {
        didSet {
            applySnapshot(search: search)
        }
    }

    func fetchGames(by name: String?) {
        guard let name = name,
              !name.isEmpty else {
            search = nil
            return
        }

        searchService.search(by: name) { [weak self] result in
            switch result {
            case let .success(search):
                self?.search = search
            case let .failure(error):
                print(error)
            }
        }
    }

    func applySnapshot(search: Search?, animatingDifferences: Bool = true) {
        var snapshot = Global.SearchSnapshot()
        if let search = search {
            snapshot.appendSections([search])
            snapshot.appendItems(search.games, toSection: search)
        }
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
