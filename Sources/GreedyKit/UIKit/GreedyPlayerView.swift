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

    typealias DisplayLinkFactory = (
        _ target: Any,
        _ selector: Selector
    ) -> DisplayLinkProtocol

    private var displayLink: DisplayLinkProtocol?
    private let renderer: VideoRendererProtocol
    private let renderView: RenderViewProtocol

    private let displayLinkFactory: DisplayLinkFactory
    private var playerItemObserver: AnyCancellable?

    // MARK: - Lifecycle

    init(
        frame: CGRect = .zero,
        renderer: VideoRendererProtocol,
        renderView: RenderViewProtocol,
        displayLinkFactory: @escaping DisplayLinkFactory
    ) {
        self.renderer = renderer
        self.renderView = renderView
        self.displayLinkFactory = displayLinkFactory
        super.init(frame: frame)

        renderView.configure(in: self)
    }

    public override convenience init(frame: CGRect) {
        self.init(
            frame: frame,
            renderer: VideoRenderer(),
            renderView: BackedRenderView(),
            displayLinkFactory: { target, selector in
                CADisplayLink(target: target, selector: selector)
            }
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        if window == nil {
            pauseRendering()
        } else {
            resumeRendering()
        }
    }

    // MARK: - Private Methods

    private func resumeRendering() {
        if displayLink == nil {
            displayLink = displayLinkFactory(self, #selector(displayLinkDidRefresh))
            displayLink?.add(to: .current, forMode: .common)
        }
        displayLink?.isPaused = (player?.currentItem == nil)
    }

    private func pauseRendering() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func displayLinkDidRefresh() {
        guard let player else { return }
        let itemTime = player.currentTime()

        Task { [weak self] in
            guard let self else { return }
            if let buffer = await renderer.frame(at: itemTime) {
                await renderView.enqueueBuffer(buffer)
            }
        }
    }

    private func attachAndResumeIfNeeded(_ item: AVPlayerItem) async {
        if window != nil {
            displayLink?.isPaused = false
        }
        await renderer.attach(to: item)
    }

    private func addPlayerItemObserver() {
        guard let player else {
            displayLink?.isPaused = true
            return
        }

        playerItemObserver = player.publisher(for: \.currentItem)
            .compactMap { $0 }
            .sink { [weak self] item in
                guard let self else { return }
                Task { await attachAndResumeIfNeeded(item) }
            }
    }
}
