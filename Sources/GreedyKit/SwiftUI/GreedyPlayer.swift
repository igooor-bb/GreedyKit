//
//  GreedyPlayer.swift
//  GreedyKit
//
//  Created by Igor Belov on 11.09.2022.
//

import AVFoundation
import SwiftUI

/// A SwiftUI view that renders the visual output of an `AVPlayer` while
/// optionally preventing it from appearing in screenshots and screen recordings.
///
/// Use `GreedyPlayer` wherever you embed video content that must remain
/// hidden in captured media.
///
/// ```swift
/// GreedyPlayer(
///     avPlayer,
///     preventsCapture: true,
///     contentGravity: .fill
/// )
/// .frame(height: 240)
/// ```
public struct GreedyPlayer: UIViewRepresentable {
    
    // MARK: -  Properties
    
    private let player: AVPlayer
    private let preventsCapture: Bool
    private let contentGravity: ContentGravity

    // MARK: -  Public API

    /// Creates a GreedyPlayer view.
    ///
    /// - Parameters:
    ///   - player: The `AVPlayer` whose visual output the view displays.
    ///   - preventsCapture: Indicates whether the view should hide its contents
    ///   from screenshots and screen recordings.
    ///   - contentGravity: Defines how the image is rendered within the view’s bounds.
    public init(
        _ player: AVPlayer,
        preventsCapture: Bool = false,
        contentGravity: ContentGravity = .fit
    ) {
        self.player = player
        self.preventsCapture = preventsCapture
        self.contentGravity = contentGravity
    }
    
    // MARK: - Requirements

    public func makeUIView(context: Context) -> GreedyPlayerView {
        GreedyPlayerView()
    }

    public func updateUIView(_ uiView: GreedyPlayerView, context: Context) {
        uiView.player = self.player
        uiView.preventsCapture = preventsCapture
        uiView.contentGravity = contentGravity
    }
}
