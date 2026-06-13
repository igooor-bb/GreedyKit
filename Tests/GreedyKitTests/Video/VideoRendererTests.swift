//
//  VideoRendererTests.swift
//  GreedyKit
//
//  Created by Igor Belov on 14.06.2026.
//

import Testing

@testable import GreedyKit

@MainActor @Suite struct VideoRendererTests {

    @Test("Attaching to a new item removes output from previous item")
    func testAttachRemovesOutputFromPreviousItem() async {
        let sut = VideoRenderer()
        let firstItem = TestUtils.makePlayerItem()
        let secondItem = TestUtils.makePlayerItem()

        await sut.attach(to: firstItem)
        #expect(firstItem.outputs.count == 1)

        await sut.attach(to: secondItem)

        #expect(firstItem.outputs.isEmpty)
        #expect(secondItem.outputs.count == 1)
    }

    @Test("detach removes output from attached item")
    func testDetachRemovesOutputFromAttachedItem() async {
        let sut = VideoRenderer()
        let item = TestUtils.makePlayerItem()

        await sut.attach(to: item)
        #expect(item.outputs.count == 1)

        await sut.detach()

        #expect(item.outputs.isEmpty)
    }
}
