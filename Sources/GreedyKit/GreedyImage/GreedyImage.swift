//
//  GreedyImage.swift
//  GreedyKit
//
//  Created by Igor Belov on 03.09.2022.
//

import UIKit
import AVFoundation

final public class GreedyUIImage: UIView {
    override public class var layerClass: AnyClass {
        AVSampleBufferDisplayLayer.self
    }

    override public var layer: AVSampleBufferDisplayLayer {
        guard let layer = super.layer as? AVSampleBufferDisplayLayer else {
            fatalError("Unable to create a layer due to unknown error")
        }
        return layer
    }

    public var image: UIImage? {
        didSet {
            if let newImage = image {
                replaceImage(with: newImage)
            }
        }
    }

    public var preventsCapture: Bool {
        get {
            layer.preventsCapture
        }
        set {
            layer.preventsCapture = true
        }
    }

    public var contentGravity: GreedyContentMode {
        get {
            GreedyContentMode.fromGravity(layer.videoGravity)
        }
        set {
            layer.videoGravity = newValue.toGravity
        }
    }

    private func replaceImage(with newImage: UIImage) {
        guard let sampleBuffer = newImage.cgImage?.sampleBuffer else { return }
        self.layer.enqueue(sampleBuffer)
    }

    private func removeImage() {
        layer.flushAndRemoveImage()
    }
}
