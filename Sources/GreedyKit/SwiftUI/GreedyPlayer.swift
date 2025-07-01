//
//  GreedyPlayer.swift
//  GreedyKit
//
//  Created by Igor Belov on 11.09.2022.
//

import AVFoundation
import SwiftUI

public struct GreedyPlayer: UIViewRepresentable {
    private let player: AVPlayer
    private let preventsCapture: Bool
    private let contentGravity: AVLayerVideoGravity

    public init(
        player: AVPlayer,
        preventsCapture: Bool,
        contentGravity: AVLayerVideoGravity = .resizeAspect
    ) {
        self.player = player
        self.preventsCapture = preventsCapture
        self.contentGravity = contentGravity
    }

    public func makeUIView(context: Context) -> GreedyPlayerView {
        GreedyPlayerView()
    }

    public func updateUIView(_ uiView: GreedyPlayerView, context: Context) {
        uiView.player = self.player
        uiView.preventsCapture = preventsCapture
        uiView.contentGravity = contentGravity
    }
}
