//
//  HomeViewModel.swift
//  GameLog
//
//  Created by duckbok on 2021/09/17.
//

final class HomeViewModel {

    var dataSource: Global.GameDataSource?

    private let homeService = HomeService()

    private var sections: [Section] = [] {
        didSet {
            applySnapshot(sections: sections)
        }
    }

    func loadSections() {
        homeService.load { [weak self] result in
            switch result {
            case let .success(recommendation):
                self?.sections = recommendation.sections
            case let .failure(error):
                print(error)
            }
        }
    }

    private func applySnapshot(sections: [Section], animatingDifferences: Bool = true) {
        var snapshot = Global.GameSnapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.games, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
