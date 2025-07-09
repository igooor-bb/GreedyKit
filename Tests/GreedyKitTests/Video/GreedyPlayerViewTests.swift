//
//  GreedyPlayerViewTests.swift
//  GreedyKit
//
//  Created by Igor Belov on 04.07.2025.
//

import AVFoundation
import Testing
import UIKit

@testable import GreedyKit

@MainActor @Suite final class GreedyPlayerViewTests {

    // MARK: - Fixtures

    private let window = UIWindow()
    private var producedLinks: [MockDisplayLink] = []

    private lazy var renderActor = MockVideoRenderer()
    private lazy var renderView = MockRenderView()
    private lazy var sut = makeSUT()

    private func makeSUT() -> GreedyPlayerView {
        GreedyPlayerView(
            renderer: renderActor,
            renderView: renderView,
            displayLinkFactory: { [unowned self] target, selector in
                let link = MockDisplayLink()
                if let object = target as? NSObjectProtocol {
                    link.setup { [weak object] in object?.perform(selector) }
                }
                self.producedLinks.append(link)
                return link
            }
        )
    }

    // MARK: - Tests

    @Test("Rendering starts only when view is on-screen")
    func testAttachAndLinkAfterWindow() async throws {
        let player = TestUtils.makePlayer()

        sut.player = player

        await Task.yield()
        try #require(await renderActor.attached === player.currentItem)
        #expect(producedLinks.isEmpty)

        window.addSubview(sut)
        await Task.yield()

        #expect(producedLinks.count == 1)
        #expect(producedLinks[0].isPaused == false)
    }

    @Test("preventsCapture is forwarded")
    func testPreventsCaptureForwarding() {
        sut.preventsCapture = true
        sut.preventsCapture = false
        #expect(renderView.preventsLog == [true, false])
    }

    @Test("contentGravity is forwarded")
    func testContentGravityForwarding() {
        sut.contentGravity = .fill
        sut.contentGravity = .stretch
        sut.contentGravity = .fit
        #expect(renderView.gravityLog == [.resizeAspectFill, .resize, .resizeAspect])
    }

    @Test("displayLink tick triggers renderer.frame when visible")
    func testDisplayLinkTickTriggersRenderer() async throws {
        sut.player = TestUtils.makePlayer()
        window.addSubview(sut)

        await Task.yield()
        let link = try #require(producedLinks.first)
        link.isPaused = false
        link.fire()

        await Task.yield()
        #expect(await renderActor.calls.count == 1)
    }

    @Test("Removal from window pauses and releases link")
    func testPauseAndInvalidateOnWindowRemoval() async throws {
        window.addSubview(sut)

        await Task.yield()
        let firstLink = try #require(producedLinks.first)

        sut.removeFromSuperview()
        await Task.yield()

        #expect(firstLink.isInvalidated == true)
        #expect(sut.window == nil)
    }

    @Test("Re‑adding view creates new displayLink instance")
    func testReaddingCreatesNewDisplayLink() async throws {
        window.addSubview(sut)

        await Task.yield()
        let link1 = try #require(producedLinks.first)

        sut.removeFromSuperview()
        await Task.yield()
        #expect(link1.isInvalidated)

        window.addSubview(sut)
        await Task.yield()

        #expect(producedLinks.count == 2)
        #expect(producedLinks.last !== link1)
    }

    @Test("Setting player to nil pauses rendering")
    func testPlayerNilPausesDisplayLink() async throws {
        sut.player = TestUtils.makePlayer()
        window.addSubview(sut)

        await Task.yield()

        let link = try #require(producedLinks.last)
        link.isPaused = false

        sut.player = nil
        await Task.yield()

        #expect(link.isPaused == true)
    }

    @Test("Changing player.currentItem triggers re-attach")
    func testChangingPlayerItemTriggersAttach() async throws {
        let player = TestUtils.makePlayer()
        sut.player = player
        window.addSubview(sut)

        await Task.yield()
        #expect(await renderActor.attached === player.currentItem)

        let newItem = TestUtils.makePlayerItem()
        player.replaceCurrentItem(with: newItem)

        await Task.yield()
        #expect(await renderActor.attached === newItem)
    }

    @Test("View is deallocated when no strong references remain")
    func playerViewIsDeallocatedWhenOrphan() throws {
        weak var weakRef: GreedyPlayerView?

        autoreleasepool {
            let view = GreedyPlayerView()
            weakRef = view
        }

        RunLoop.current.run(until: Date())
        #expect(
            weakRef == nil,
            "GreedyPlayerView should be released when no strong refs remain"
        )
    }

    @Test("View is deallocated when removed from superview")
    func playerViewIsDeallocatedWhenRemovedFromSuperview() throws {
        let container = UIView()
        weak var weakRef: GreedyPlayerView?

        autoreleasepool {
            let view = GreedyPlayerView()
            weakRef = view

            container.addSubview(view)
            view.removeFromSuperview()
        }

        RunLoop.current.run(until: Date())
        #expect(
            weakRef == nil,
            "GreedyPlayerView should be released after removal from superview"
        )
    }
}
