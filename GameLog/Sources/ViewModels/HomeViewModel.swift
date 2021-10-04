//
//  HomeViewModel.swift
//  GameLog
//
//  Created by duckbok on 2021/09/17.
//

import UIKit

struct HomeViewModel {

    var changed: (() -> Void)?

    var dataSource: Global.GameDataSource?

    func applySnapshot(sections: [Section], animatingDifferences: Bool = true) {
        var snapshot = Global.GameSnapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.games, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
