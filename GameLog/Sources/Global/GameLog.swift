//
//  GameLog.swift
//  GameLog
//
//  Created by duckbok on 2021/09/16.
//

import UIKit

enum GameLog {

    typealias GameDataSource = UICollectionViewDiffableDataSource<Section, Game>
    typealias GameSnapshot = NSDiffableDataSourceSnapshot<Section, Game>

    enum Style {
        static let mainColor: UIColor = .systemIndigo
    }
}
