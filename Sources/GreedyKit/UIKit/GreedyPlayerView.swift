//
//  GreedyPlayerView.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import AVFoundation
import Combine
import UIKit

public final class GreedyPlayerView: UIView {

    // MARK: Public

    public var player: AVPlayer? {
        didSet { addPlayerItemObserver() }
    }

    public var preventsCapture: Bool = false {
        didSet { renderView.preventsCapture = preventsCapture }
    }

    public var contentGravity: AVLayerVideoGravity = .resizeAspect {
        didSet { renderView.contentGravity = contentGravity }
    }

    // MARK: Properties

    private lazy var renderer = VideoRenderActor(debugName: "GreedyPlayerView")

    private let renderView = BackedRenderView()
    private var playerItemObserver: AnyCancellable?

    private lazy var displayLink = CADisplayLink(
        target: self,
        selector: #selector(displayLinkDidRefresh(link:))
    )

    // MARK: Lifecycle

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

    // MARK: Rendering

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
