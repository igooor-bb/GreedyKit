//
//  HomeViewController.swift
//  iOSGreedyKit
//
//  Created by Igor Belov on 07.09.2022.
//

import UIKit

final class HomeViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 20
        return view
    }()

    private lazy var imageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go to Image", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()

    private lazy var videoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go to Video", for: .normal)
        button.setTitleColor(UIColor.purple, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(stackView)
        setupStackView()
        setupButtons()
    }

    private func setupStackView() {
        stackView.addArrangedSubview(imageButton)
        stackView.addArrangedSubview(videoButton)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    private func setupButtons() {
        imageButton.addTarget(self, action: #selector(didPressImageButton), for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(didPressVideoButton), for: .touchUpInside)
    }

    @objc
    private func didPressImageButton() {
        let controller = ImageViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc
    private func didPressVideoButton() {
        let controller = VideoViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
