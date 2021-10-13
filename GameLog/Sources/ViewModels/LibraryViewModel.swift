//
//  LibraryViewModel.swift
//  GameLog
//
//  Created by duckbok on 2021/10/13.
//

import UIKit

final class LibraryViewModel {

    var dataSource: Global.LibraryDataSource?

    private let libraryService = LibraryService()

    private var library: Library? {
        didSet {
            if let library = library {
                applySnapshot(library: library)
            }
        }
    }

    func loadLibrary(page: Int,
                     sortMethod: LibraryService.SortMethod = .createdTime,
                     sortOrder: LibraryService.SortOrder = .descending) {
        libraryService.load(page: page, sortMethod: sortMethod, sortOrder: sortOrder) { [weak self] result in
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
