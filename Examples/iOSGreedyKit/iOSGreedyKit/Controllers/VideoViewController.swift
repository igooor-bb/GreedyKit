//
//  VideoViewController.swift
//  iOSGreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import UIKit
import AVFoundation
import GreedyKit

final class VideoViewController: UIViewController {
    private lazy var playerView: GreedyPlayerView = {
        let view = GreedyPlayerView()
        view.contentGravity = .resizeAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var controlsView: ContentControlsView = {
        let view = ContentControlsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var localVideo: AVAsset = {
        guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4") else {
            fatalError("Test video is missing in the bundle")
        }
        return AVAsset(url: url)
    }()

    private let player = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPlayerView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addVideo()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(playerView)
        view.addSubview(controlsView)
        setupLayout()
    }

    private func setupLayout() {
        setupPlayerView()
        setupControlsView()
    }

    private func setupPlayerView() {
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: 16),
            playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor),
            playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        playerView.player = player

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }

    @objc
    private func playerDidFinishPlaying() {
        player.seek(to: .zero)
        player.play()
    }

    private func setupControlsView() {
        controlsView.delegate = self
        NSLayoutConstraint.activate([
            controlsView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
            controlsView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 16),
            playerView.trailingAnchor.constraint(equalTo: controlsView.trailingAnchor)
        ])
    }

    private func addVideo() {
        let playerItem = AVPlayerItem(asset: localVideo)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
}

extension VideoViewController: ContentControlsDelegate {
    func didChangeToggleValue(to value: Bool) {
        playerView.preventsCapture = value
    }
}
