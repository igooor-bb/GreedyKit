//
//  GreedyImage.swift
//  GreedyKit
//
//  Created by Igor Belov on 11.09.2022.
//

import AVFoundation
import SwiftUI

/// A SwiftUI view that renders an image while optionally preventing it
/// from appearing in system screenshots and screen recordings.
///
/// Use `GreedyImage` wherever you would use `Image`, but require additional
/// control over capture protection or content scaling.
///
/// ```swift
/// GreedyImage(
///     photo,
///     preventsCapture: true,
///     contentGravity: .fill
/// )
/// .frame(width: 200, height: 200)
/// ```
public struct GreedyImage: UIViewRepresentable {

    // MARK: - Properties

    private let image: UIImage
    private let preventsCapture: Bool
    private let contentGravity: ContentGravity

    // MARK: - Public API

    /// Creates a GreedyImage view.
    ///
    /// - Parameters:
    ///   - image: The `UIImage` to display.
    ///   - preventsCapture: Indicates whether the view should hide its contents
    ///   from screenshots and screen recordings.
    ///   - contentGravity: Defines how the image is rendered within the view’s bounds.
    public init(
        _ image: UIImage,
        preventsCapture: Bool = false,
        contentGravity: ContentGravity = .fit
    ) {
        self.preventsCapture = preventsCapture
        self.contentGravity = contentGravity
        self.image = image
    }

    // MARK: - Requirements

    public func makeUIView(context: Context) -> GreedyImageView {
        let view = GreedyImageView()
        view.image = image
        return view
    }

    public func updateUIView(_ uiView: GreedyImageView, context: Context) {
        uiView.preventsCapture = preventsCapture
        uiView.contentGravity = contentGravity
    }
}
