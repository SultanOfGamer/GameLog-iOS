//
//  HomeViewModel.swift
//  GameLog
//
//  Created by duckbok on 2021/09/17.
//

import UIKit

final class HomeViewModel {

    var dataSource: Global.GameDataSource?

    private let homeServcie = HomeService()

    private var sections: [Section] = [] {
        didSet {
            applySnapshot(sections: sections)
        }
    }

    func loadSections() {
        homeServcie.load { [weak self] result in
            switch result {
            case let .success(sections):
                self?.sections = sections
            case let .failure(error):
                print(error)
            }
        }
    }

    func applySnapshot(sections: [Section], animatingDifferences: Bool = true) {
        var snapshot = Global.GameSnapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.games, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
