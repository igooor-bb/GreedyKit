//
//  Mocks.swift
//  GreedyKit
//
//  Created by Igor Belov on 04.07.2025.
//

import AVFoundation
import CoreMedia
import UIKit

@testable import GreedyKit

// MARK: - VideoRenderer

actor MockVideoRenderer: VideoRendererProtocol {
    private(set) var attached: AVPlayerItem?
    private(set) var calls: [CMTime] = []

    func attach(to item: AVPlayerItem) async {
        attached = item
    }

    func frame(at time: CMTime) async -> CMSampleBuffer? {
        calls.append(time)
        return nil
    }
}

// MARK: - MockRenderView

final class MockRenderView: UIView, RenderViewProtocol {
    var preventsCapture: Bool = false {
        didSet {
            preventsLog.append(preventsCapture)
        }
    }

    var contentGravity: AVLayerVideoGravity = .resizeAspect {
        didSet {
            gravityLog.append(contentGravity)
        }
    }

    private(set) var preventsLog: [Bool] = []
    private(set) var gravityLog: [AVLayerVideoGravity] = []
    private(set) var buffers: [CMSampleBuffer] = []

    func enqueueBuffer(_ buffer: CMSampleBuffer) async {
        buffers.append(buffer)
    }

    func clearLayer() async {
        buffers.removeAll()
    }
}

// MARK: - DisplayLink

final class MockDisplayLink: DisplayLinkProtocol {
    var isPaused = true

    private(set) var isAddedToRunLoop = false
    private(set) var isInvalidated = false

    private var tick: (() -> Void)?

    init() {}

    func add(to runLoop: RunLoop, forMode: RunLoop.Mode) {
        isAddedToRunLoop = true
    }

    func invalidate() {
        isInvalidated = true
    }

    func setup(_ handler: @escaping () -> Void) {
        tick = handler
    }

    func fire() {
        tick?()
    }
}
