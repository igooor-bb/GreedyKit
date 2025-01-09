//
//  GreedyRenderView.swift
//  GreedyKit
//
//  Created by Igor Belov on 03.09.2022.
//

import UIKit
import AVFoundation

final class GreedyRenderView: UIView {
    override class var layerClass: AnyClass {
        AVSampleBufferDisplayLayer.self
    }

    override var layer: AVSampleBufferDisplayLayer {
        guard let layer = super.layer as? AVSampleBufferDisplayLayer else {
            fatalError("Unable to create a layer due to unknown error")
        }
        return layer
    }

    @Proxy(\.layer.preventsCapture)
    var preventsCapture: Bool

    @Proxy(\.layer.videoGravity)
    var contentGravity: AVLayerVideoGravity

    @MainActor
    func enqueueBuffer(_ buffer: CMSampleBuffer) {
        layer.flush()
        layer.enqueue(buffer)
    }

    @MainActor
    func clearLayer() {
        layer.flushAndRemoveImage()
    }
}
