//
//  LibraryHeaderView.swift
//  GameLog
//
//  Created by duckbok on 2021/10/14.
//

import UIKit

final class LibraryHeaderView: UICollectionReusableView {

    static let reuseIdentifier = String(describing: LibraryHeaderView.self)

    let sortingMethodButton: UIButton = {
        let button = UIButton()
        button.setTitle(Library.SortingMethod.createdTime.name, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize,
                                       weight: .bold)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(.label, for: .normal)
        return button
    }()

    let sortingOrderButton: UIButton = {
        let button = UIButton()
//        button.setImage(Library.SortingOrder.descending.sign, for: .normal)
        button.tintColor = Global.Style.mainColor
        return button
    }()

    let sortingButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configureSortingButtonStackView()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: Configure

    private func configureSortingButtonStackView() {
        addSubview(sortingButtonStackView)
        NSLayoutConstraint.activate([
            sortingButtonStackView.topAnchor.constraint(equalTo: readableContentGuide.topAnchor),
            sortingButtonStackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            sortingButtonStackView.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor),
            sortingButtonStackView.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor)
        ])

        sortingButtonStackView.addArrangedSubview(sortingMethodButton)
        sortingButtonStackView.addArrangedSubview(sortingOrderButton)
    }
}
