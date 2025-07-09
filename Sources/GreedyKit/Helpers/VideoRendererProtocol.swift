//
//  VideoRendererProtocol.swift
//  GreedyKit
//
//  Created by Igor Belov on 04.07.2025.
//

import AVFoundation

protocol VideoRendererProtocol: Sendable {
    func attach(to item: AVPlayerItem) async
    func frame(at time: CMTime) async -> CMSampleBuffer?
}
