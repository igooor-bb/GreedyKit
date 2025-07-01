//
//  BackedRenderView.swift
//  GreedyKit
//
//  Created by Igor Belov on 03.09.2022.
//

import AVFoundation
import UIKit

final class BackedRenderView: UIView {

    // MARK: Layers

    override class var layerClass: AnyClass {
        AVSampleBufferDisplayLayer.self
    }

    override var layer: AVSampleBufferDisplayLayer {
        guard let layer = super.layer as? AVSampleBufferDisplayLayer else {
            fatalError("Unable to create a layer due to unknown error")
        }
        return layer
    }

    // MARK: Properties

    var preventsCapture: Bool = false {
        didSet { layer.preventsCapture = preventsCapture }
    }

    var contentGravity: AVLayerVideoGravity = .resizeAspect {
        didSet { layer.videoGravity = contentGravity }
    }

    // MARK: Interface

    func enqueueBuffer(_ buffer: CMSampleBuffer) async {
        layer.flush()
        layer.enqueue(buffer)
    }

    func clearLayer() async {
        layer.flushAndRemoveImage()
    }
}
