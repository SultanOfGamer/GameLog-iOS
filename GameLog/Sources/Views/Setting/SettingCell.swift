//
//  SettingCell.swift
//  GameLog
//
//  Created by duckbok on 2021/11/07.
//

import UIKit

final class SettingCell: UITableViewCell {

    private enum Style {
        static let imageSize: CGFloat = 50
    }

    static let reuseIdentifier = String(describing: SettingCell.self)

    func setContent(rowContent: SettingContent.Row) {
        var content = defaultContentConfiguration()

        content.text = rowContent.text
        content.secondaryText = rowContent.secondaryText
        if rowContent.image != nil {
            content.image = rowContent.image
            content.imageProperties.maximumSize = CGSize(width: Style.imageSize, height: Style.imageSize)
            content.imageProperties.cornerRadius = Style.imageSize/2
            content.textProperties.font = .preferredFont(forTextStyle: .headline)
            content.secondaryTextProperties.font = .preferredFont(forTextStyle: .subheadline)
        }

        contentConfiguration = content
        accessoryType = rowContent.accessoryType
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        accessoryType = .none
        contentConfiguration = nil
    }
}
