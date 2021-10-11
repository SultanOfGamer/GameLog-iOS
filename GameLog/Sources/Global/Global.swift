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

    enum Style {
        static let mainColor: UIColor = .systemIndigo
    }
}
