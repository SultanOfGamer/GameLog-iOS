//
//  Global.swift
//  GameLog
//
//  Created by duckbok on 2021/09/16.
//

import UIKit

enum Global {

    typealias GameDataSource = UICollectionViewDiffableDataSource<Section, Section.Game>
    typealias GameSnapshot = NSDiffableDataSourceSnapshot<Section, Section.Game>

    typealias LibraryDataSource = UICollectionViewDiffableDataSource<Library, Library.Game>
    typealias LibrarySnapshot = NSDiffableDataSourceSnapshot<Library, Library.Game>

    static let coverPlaceholder: UIImage = UIImage(named: "CoverPlaceholder")!
    static let screenshotPlaceholder: UIImage = UIImage(named: "ScreenshotPlaceholder")!

    enum Style {
        static let mainColor: UIColor = .systemIndigo
    }
}
