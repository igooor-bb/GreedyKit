//
//  GreedyImageView.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import AVFoundation
import CoreImage
import UIKit

/// A view that displays an image and can optionally prevent it from
/// appearing in system screenshots and screen recordings.
///
/// Use `GreedyImageView` when presenting sensitive visual content that
/// should remain hidden in captured media.
///
/// The default configuration shows the image normally.
public final class GreedyImageView: UIView {

    // MARK: - Public API
    
    /// The image rendered by the view.
    ///
    /// Assigning a new value replaces any previous image.
    /// Set this property to `nil` to clear the current content.
    public var image: UIImage? {
        didSet {
            if let image {
                setImage(image)
            } else {
                removeImage()
            }
        }
    }

    /// Indicates whether the view should hide its contents
    /// from screenshots and screen recordings.
    ///
    /// The default value is `false`.
    public var preventsCapture: Bool = false {
        didSet { renderView.preventsCapture = preventsCapture }
    }
    
    /// Defines how the image is rendered within the view’s bounds.
    ///
    /// The default value is `.fit`.
    public var contentGravity: ContentGravity = .fit {
        didSet { renderView.contentGravity = contentGravity.avValue }
    }

    // MARK: - Properties

    private let renderView = BackedRenderView()

    private lazy var sampleBufferFactory = SampleBufferFactory()
    private lazy var renderer = CoreGraphicsRenderer(
        debugName: "GreedyImageView",
        cacheIntermediates: true
    )

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        renderView.configure(in: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    
    private func setImage(_ uiImage: UIImage) {
        Task {
            if let cgImage = uiImage.cgImage {
                await enqueueBuffer(from: cgImage)
            }
        }
    }

    private func removeImage() {
        Task {
            await renderView.clearLayer()
        }
    }

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
