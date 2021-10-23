//
//  ReviewViewController.swift
//  GameLog
//
//  Created by duckbok on 2021/10/23.
//

import UIKit

final class ReviewViewController: UIViewController {

    private enum Style {
        static let alertTitle: String = "리뷰 등록에 문제가 생겼어요 😭"
        static let layoutMargin: CGFloat = 16
        static let title: String = "리뷰 작성"
    }

    private let gameViewModel: GameViewModel

    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.becomeFirstResponder()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    // MARK: - Initializer

    init(gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
        super.init(nibName: nil, bundle: nil)

        reviewTextView.delegate = self
        title = Style.title
        view.backgroundColor = .systemBackground

        addKeyboardObserver()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextView.text = gameViewModel.userGame?.memo
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textViewMoveUp),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textViewMoveDown),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func configureLayout() {
        view.addSubview(reviewTextView)
        NSLayoutConstraint.activate([
            reviewTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: Style.layoutMargin),
            reviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Style.layoutMargin),
            reviewTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Style.layoutMargin),
            reviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Style.layoutMargin)
        ])
    }

    private func configureNavigationBar() {
        let cancelBarButtonItem = UIBarButtonItem(title: "닫기",
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(cancelReview))
        let doneBarButtonItem = UIBarButtonItem(title: "등록",
                                                style: .done,
                                                target: self,
                                                action: #selector(updateReview))
        cancelBarButtonItem.tintColor = .label
        doneBarButtonItem.isEnabled = false
        doneBarButtonItem.tintColor = Global.Style.mainColor

        navigationItem.setLeftBarButton(cancelBarButtonItem, animated: true)
        navigationItem.setRightBarButton(doneBarButtonItem, animated: true)
    }
}

// MARK: - Action

extension ReviewViewController {

    @objc private func textViewMoveUp(_ notificaiton: Notification) {
        guard let userInfo = notificaiton.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        reviewTextView.contentInset = keyboardInset
        reviewTextView.scrollIndicatorInsets = keyboardInset
    }

    @objc private func textViewMoveDown(_ notificaiton: Notification) {
        let keyboardInset: UIEdgeInsets = .zero
        reviewTextView.contentInset = keyboardInset
        reviewTextView.scrollIndicatorInsets = keyboardInset
    }

    @objc private func cancelReview() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func updateReview() {
        guard reviewTextView.text != (gameViewModel.userGame?.memo ?? "") else { return }
        let memo: String? = reviewTextView.text.isEmpty ? nil : reviewTextView.text

        if gameViewModel.userGame?.status == nil {
            gameViewModel.addUserGame(memo: memo, status: .done, completion: updatePostProcess)
        } else {
            gameViewModel.updateUserGame(memo: memo, status: .done, completion: updatePostProcess)
        }
    }

    private func updatePostProcess(_ error: NetworkRepository.Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if let error = error {
                self.presentAlertController(.init(title: Style.alertTitle,
                                                  message: error.localizedDescription,
                                                  preferredStyle: .alert))
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension ReviewViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView.text == (gameViewModel.userGame?.memo ?? "") {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}
