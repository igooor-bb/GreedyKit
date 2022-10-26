//
//  ImageViewController.swift
//  iOSGreedyKit
//
//  Created by Igor Belov on 03.09.2022.
//

import UIKit
import GreedyKit

final class ImageViewController: UIViewController {
    private lazy var imageView: GreedyImageView = {
        let view = GreedyImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var controlsView: ContentControlsView = {
        let view = ContentControlsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var localImage: UIImage = {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addImage()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(controlsView)
        setupLayout()
    }
    
    private func setupLayout() {
        setupImageView()
        setupControlsView()
    }

    private func setupImageView() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupControlsView() {
        controlsView.delegate = self
        NSLayoutConstraint.activate([
            controlsView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            controlsView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: controlsView.trailingAnchor)
        ])
    }

    private func addImage() {
        imageView.setImage(localImage)
    }
}

extension ImageViewController: ContentControlsDelegate {
    func didChangeToggleValue(to value: Bool) {
        self.imageView.preventsCapture = value
    }
}
