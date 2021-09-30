//
//  HomeViewModel.swift
//  GameLog
//
//  Created by duckbok on 2021/09/17.
//

import UIKit

struct HomeViewModel {

    var changed: (() -> Void)?

    var dataSource: GameLog.GameDataSource?

    func applySnapshot(sections: [Section], animatingDifferences: Bool = true) {
        var snapshot = GameLog.GameSnapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.games, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
