//
//  GreedyImageView.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import AVFoundation
import CoreImage
import UIKit

public final class GreedyImageView: UIView {

    // MARK: Public

    public var preventsCapture: Bool = false {
        didSet { renderView.preventsCapture = preventsCapture }
    }

    public var contentGravity: AVLayerVideoGravity = .resizeAspect {
        didSet { renderView.contentGravity = contentGravity }
    }

    // MARK: Properties

    private let renderView = BackedRenderView()
    private lazy var sampleBufferFactory = SampleBufferFactory()

    private lazy var renderer = CoreGraphicsRenderer(
        debugName: "GreedyImageView",
        cacheIntermediates: true
    )

    // MARK: Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        renderView.configure(in: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Interface

    public func setImage(_ cgImage: CGImage) {
        Task {
            await enqueueBuffer(from: cgImage)
        }
    }

    public func setImage(_ uiImage: UIImage) {
        Task {
            if let cgImage = uiImage.cgImage {
                await enqueueBuffer(from: cgImage)
            }
        }
    }

    public func setImage(_ ciImage: CIImage) {
        Task {
            if let cgImage = await renderer.cgImage(from: ciImage) {
                await enqueueBuffer(from: cgImage)
            }
        }
    }

    public func removeImage() {
        Task {
            await renderView.clearLayer()
        }
    }

    // MARK: Helpers

    private func enqueueBuffer(from cgImage: CGImage) async {
        guard let buffer = await sampleBufferFactory.sampleBuffer(
            fromCGImage: cgImage,
            presentationTimeStamp: .zero
        ) else {
            return
        }
        await renderView.enqueueBuffer(buffer)
    }
}
