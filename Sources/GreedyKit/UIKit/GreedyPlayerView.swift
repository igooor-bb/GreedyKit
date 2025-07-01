//
//  GreedyPlayerView.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import AVFoundation
import Combine
import UIKit

/// A view that renders the visual output of an `AVPlayer` while optionally
/// hiding that output from screenshots and screen recordings.
///
/// Use `GreedyPlayerView` to present sensitive video content that must
/// remain invisible in captured media.
///
/// The default configuration plays the video normally.
public final class GreedyPlayerView: UIView {

    // MARK: - Public API

    /// The player whose media is displayed by the view.
    ///
    /// ```swift
    /// playerView.player = AVPlayer(url: videoURL)
    /// ```
    ///
    /// Assigning a new player replaces any previously set player.
    public var player: AVPlayer? {
        didSet { addPlayerItemObserver() }
    }

    /// Indicates whether the view should hide its contents
    /// from screenshots and screen recordings.
    ///
    /// The default value is `false`.
    public var preventsCapture: Bool = false {
        didSet { renderView.preventsCapture = preventsCapture }
    }

    /// Defines how the image is rendered within the view’s bounds.
    ///
    /// The default value is `.fit`.
    public var contentGravity: ContentGravity = .fit {
        didSet { renderView.contentGravity = contentGravity.avValue }
    }

    // MARK: - Properties

    private lazy var renderer = VideoRenderActor(debugName: "GreedyPlayerView")

    private let renderView = BackedRenderView()
    private var playerItemObserver: AnyCancellable?

    private lazy var displayLink = CADisplayLink(
        target: self,
        selector: #selector(displayLinkDidRefresh(link:))
    )

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        renderView.configure(in: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            dismantle()
        }
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        initializeDisplayLink()
    }

    // MARK: - Private Methods

    private func dismantle() {
        displayLink.invalidate()
        playerItemObserver?.cancel()
    }

    private func initializeDisplayLink() {
        displayLink.add(to: .current, forMode: .common)
        displayLink.isPaused = true
    }

    @objc private func displayLinkDidRefresh(link: CADisplayLink) {
        guard let player else { return }
        let itemTime = player.currentTime()

        Task { [weak self] in
            guard let self else { return }
            if let buffer = await renderer.frame(at: itemTime) {
                await renderView.enqueueBuffer(buffer)
            }
        }
    }

    private func addPlayerItemObserver() {
        guard let player else { return }

        playerItemObserver = player.publisher(for: \.currentItem)
            .compactMap { $0 }
            .sink { [weak self] item in
                guard let self else { return }
                Task {
                    await self.renderer.attach(to: item)
                    self.displayLink.isPaused = false
                }
            }
    }
}
