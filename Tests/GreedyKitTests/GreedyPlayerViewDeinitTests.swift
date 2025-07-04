//
//  GreedyPlayerViewDeinitTests.swift
//  GreedyKit
//
//  Created by Igor Belov on 30.06.2025.
//

import Testing
import UIKit

@testable import GreedyKit

struct GreedyPlayerViewDeinitTests {

    @Test
    @MainActor
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

    @Test
    @MainActor
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
