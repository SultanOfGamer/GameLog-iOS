//
//  LibraryViewModel.swift
//  GameLog
//
//  Created by duckbok on 2021/10/13.
//

import UIKit

final class LibraryViewModel {

    var dataSource: Global.LibraryDataSource?
    private(set) var sorting: (method: Library.SortingMethod, order: Library.SortingOrder) = (.createdTime, .descending)

    private let libraryService = LibraryService()

    private var library: Library? {
        didSet {
            guard let library = library else { return }
            applySnapshot(library: library)
        }
    }

    func loadLibrary(page: Int,
                     sortingMethod: Library.SortingMethod? = nil,
                     isSortingReverse: Bool = false) {
        sorting.method = sortingMethod ?? sorting.method
        sorting.order = isSortingReverse ? sorting.order.toggle : sorting.order

        libraryService.load(page: page,
                            sortingMethod: sorting.method,
                            sortingOrder: sorting.order) { [weak self] result in
            switch result {
            case let .success(library):
                self?.library = library
            case let .failure(error):
                print(error)
            }
        }
    }

    func applySnapshot(library: Library, animatingDifferences: Bool = true) {
        var snapshot = Global.LibrarySnapshot()
        snapshot.appendSections([library])
        snapshot.appendItems(library.data, toSection: library)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
