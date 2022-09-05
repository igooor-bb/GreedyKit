//
//  ViewController.swift
//  iOSGreedyKit
//
//  Created by Igor Belov on 03.09.2022.
//

import UIKit
import GreedyKit

class ViewController: UIViewController {
    private lazy var imageView: GreedyUIImage = {
        let view = GreedyUIImage()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var toggleView: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .magenta
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.offLabelText
        label.textColor = .black
        return label
    }()

    private let offLabelText = "Protection is OFF"
    private let onLabelText = "Protection is ON"

    lazy var localImage: UIImage = {
        guard
            let path = Bundle.main.path(forResource: "image", ofType: "jpg"),
            let image = UIImage(contentsOfFile: path)
        else {
            fatalError("Test image is missing in the bundle")
        }
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImageView()
        setupToggleView()
        setupLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addImage()
    }

    private func setupView() {
        view.backgroundColor = .white
    }

    private func setupImageView() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupToggleView() {
        view.addSubview(toggleView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: toggleView.centerXAnchor),
            toggleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24)
        ])
        toggleView.addTarget(self, action: #selector(toggleViewValueDidChange(_:)), for: .valueChanged)
    }

    private func setupLabel() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            toggleView.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            label.topAnchor.constraint(equalTo: toggleView.bottomAnchor, constant: 12)
        ])
    }

    private func addImage() {
        try? imageView.setImage(localImage)
    }
}

extension ViewController {
    @objc
    private func toggleViewValueDidChange(_ toggleView: UISwitch) {
        self.label.text = toggleView.isOn ? onLabelText : offLabelText
        self.imageView.preventsCapture = toggleView.isOn
    }
}
