//
//  BackedRenderView.swift
//  GreedyKit
//
//  Created by Igor Belov on 03.09.2022.
//

import AVFoundation
import UIKit

final class BackedRenderView: UIView, RenderViewProtocol {

    // MARK: - Internal API

    var preventsCapture: Bool = false {
        didSet { layer.preventsCapture = preventsCapture }
    }

    var contentGravity: AVLayerVideoGravity = .resizeAspect {
        didSet { layer.videoGravity = contentGravity }
    }

    // MARK: Properties

    override class var layerClass: AnyClass {
        AVSampleBufferDisplayLayer.self
    }

    override var layer: AVSampleBufferDisplayLayer {
        guard let layer = super.layer as? AVSampleBufferDisplayLayer else {
            fatalError("Unable to create a layer due to unknown error")
        }
        return layer
    }

    @available(iOS 17.0, *)
    private var renderer: AVSampleBufferVideoRenderer {
        layer.sampleBufferRenderer
    }

    // MARK: Interface

    func enqueueBuffer(_ buffer: CMSampleBuffer) async {
        if #available(iOS 17.0, *) {
            renderer.flush()
            renderer.enqueue(buffer)
        } else {
            layer.flush()
            layer.enqueue(buffer)
        }
    }

    func clearLayer() async {
        if #available(iOS 17.0, *) {
            await withCheckedContinuation { continuation in
                renderer.flush(removingDisplayedImage: true) {
                    continuation.resume()
                }
            }
        } else {
            layer.flushAndRemoveImage()
        }
    }
}
