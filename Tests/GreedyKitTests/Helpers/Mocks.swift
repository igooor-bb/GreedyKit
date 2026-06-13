//
//  Mocks.swift
//  GreedyKit
//
//  Created by Igor Belov on 04.07.2025.
//

import AVFoundation
import CoreMedia
import CoreImage
import UIKit

@testable import GreedyKit

// MARK: - VideoRenderer

@MainActor
final class MockVideoRenderer: VideoRendererProtocol {
    private(set) var attached: AVPlayerItem?
    private(set) var attachedItems: [AVPlayerItem] = []
    private(set) var detachCount = 0
    private(set) var calls: [CMTime] = []

    func attach(to item: AVPlayerItem) async {
        attached = item
        attachedItems.append(item)
    }

    func detach() async {
        detachCount += 1
        attached = nil
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
    private(set) var clearCount = 0

    func enqueueBuffer(_ buffer: CMSampleBuffer) async {
        buffers.append(buffer)
    }

    func clearLayer() async {
        clearCount += 1
        buffers.removeAll()
    }
}

// MARK: - Image Rendering

actor MockSampleBufferFactory: SampleBufferFactoryProtocol {
    private var queuedBuffers: [CMSampleBuffer?]
    private var continuations: [CheckedContinuation<CMSampleBuffer?, Never>] = []
    private var requestWaiters: [CheckedContinuation<Void, Never>] = []

    private(set) var cgImageRequestCount = 0

    var pendingRequestCount: Int {
        continuations.count
    }

    init(queuedBuffers: [CMSampleBuffer?] = []) {
        self.queuedBuffers = queuedBuffers
    }

    func sampleBuffer(
        fromPixelBuffer pixelBuffer: CVPixelBuffer,
        presentationTimeStamp time: CMTime,
        duration: CMTime
    ) async -> CMSampleBuffer? {
        if queuedBuffers.isEmpty {
            return nil
        }
        return queuedBuffers.removeFirst()
    }

    func sampleBuffer(
        fromCGImage cgImage: CGImage,
        presentationTimeStamp time: CMTime,
        duration: CMTime
    ) async -> CMSampleBuffer? {
        cgImageRequestCount += 1

        if !queuedBuffers.isEmpty {
            return queuedBuffers.removeFirst()
        }

        return await withCheckedContinuation { continuation in
            continuations.append(continuation)
            resumeRequestWaiters()
        }
    }

    func waitForPendingRequest() async {
        if !continuations.isEmpty {
            return
        }

        await withCheckedContinuation { continuation in
            requestWaiters.append(continuation)
        }
    }

    func resumeNext(with buffer: CMSampleBuffer?) {
        continuations.removeFirst().resume(returning: buffer)
    }

    private func resumeRequestWaiters() {
        let waiters = requestWaiters
        requestWaiters.removeAll()
        waiters.forEach { $0.resume() }
    }
}

final class MockCoreGraphicsRenderer: CoreGraphicsRendererProtocol {
    func cgImage(from ciImage: CIImage) async -> CGImage? {
        nil
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
