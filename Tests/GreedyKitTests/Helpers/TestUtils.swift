//
//  TestUtils.swift
//  GreedyKit
//
//  Created by Igor Belov on 06.07.2025.
//

import AVFoundation
import Foundation

enum TestUtils {
    static func makePlayer() -> AVPlayer {
        AVPlayer(playerItem: makePlayerItem())
    }

    static func makePlayerItem() -> AVPlayerItem {
        guard let url = Bundle.module.url(forResource: "sample", withExtension: "mp4") else {
            fatalError("Missing test sample file")
        }
        return AVPlayerItem(url: url)
    }
}
