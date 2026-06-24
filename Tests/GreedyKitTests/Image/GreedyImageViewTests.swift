//
//  GreedyImageViewTests.swift
//  GreedyKit
//
//  Created by Igor Belov on 14.06.2026.
//

import Testing
import UIKit

@testable import GreedyKit

@MainActor @Suite final class GreedyImageViewTests {

    private let renderView = MockRenderView()
    private let sampleBufferFactory = MockSampleBufferFactory()

    private lazy var sut = GreedyImageView(
        renderView: renderView,
        sampleBufferFactory: sampleBufferFactory
    )

    @Test("Setting image to nil clears layer and cancels pending render")
    func testSettingImageToNilCancelsPendingRender() async throws {
        sut.image = TestUtils.makeImage()

        try await waitForPendingImageRequest()

        sut.image = nil
        await Task.yield()

        #expect(renderView.clearCount == 1)

        await sampleBufferFactory.resumeNext(with: TestUtils.makeSampleBuffer())
        await Task.yield()

        #expect(renderView.buffers.isEmpty)
    }

    @Test("Failed image render clears layer")
    func testFailedImageRenderClearsLayer() async {
        let renderView = MockRenderView()
        let sampleBufferFactory = MockSampleBufferFactory(queuedBuffers: [nil])
        let sut = GreedyImageView(
            renderView: renderView,
            sampleBufferFactory: sampleBufferFactory
        )

        sut.image = TestUtils.makeImage()
        await drainImageRenderTask()

        #expect(renderView.clearCount == 1)
        #expect(renderView.buffers.isEmpty)
    }

    private func drainImageRenderTask() async {
        for _ in 0..<3 {
            await Task.yield()
        }
    }

    private func waitForPendingImageRequest() async throws {
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                let sampleBufferFactory = sampleBufferFactory

                group.addTask {
                    await sampleBufferFactory.waitForPendingRequest()
                }
                group.addTask {
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    throw WaitError.timedOut
                }

                try await group.next()
                group.cancelAll()
            }
        } catch WaitError.timedOut {
            Issue.record("Timed out waiting for image render request")
        }
    }

    private enum WaitError: Error {
        case timedOut
    }
}
