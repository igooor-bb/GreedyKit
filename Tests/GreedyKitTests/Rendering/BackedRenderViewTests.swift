//
//  BackedRenderViewTests.swift
//  GreedyKit
//
//  Created by Igor Belov on 06.07.2025.
//

import AVFoundation
import Testing

@testable import GreedyKit

@MainActor @Suite struct BackedRenderViewTests {

    @Test("layerClass is AVSampleBufferDisplayLayer")
    func testLayerClass() {
        #expect(BackedRenderView.layerClass is AVSampleBufferDisplayLayer.Type)
    }

    @Test("Property proxies modify underlying layer")
    func testProxies() {
        let sut = BackedRenderView()

        sut.preventsCapture = true
        sut.contentGravity = .resizeAspectFill
        #expect(sut.layer.preventsCapture == true)
        #expect(sut.layer.videoGravity == .resizeAspectFill)

        sut.preventsCapture = false
        sut.contentGravity = .resize
        #expect(sut.layer.preventsCapture == false)
        #expect(sut.layer.videoGravity == .resize)
    }
}
