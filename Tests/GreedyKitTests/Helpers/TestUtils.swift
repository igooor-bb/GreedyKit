//
//  TestUtils.swift
//  GreedyKit
//
//  Created by Igor Belov on 06.07.2025.
//

import AVFoundation
import Foundation
import UIKit

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

    static func makeImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }

    static func makeSampleBuffer() -> CMSampleBuffer {
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            1,
            1,
            kCVPixelFormatType_32BGRA,
            nil,
            &pixelBuffer
        )

        guard let pixelBuffer else {
            fatalError("Unable to create test pixel buffer")
        }

        guard let formatDescription = try? CMVideoFormatDescription(
            imageBuffer: pixelBuffer
        ) else {
            fatalError("Unable to create test format description")
        }

        let timingInfo = CMSampleTimingInfo(
            duration: .invalid,
            presentationTimeStamp: .zero,
            decodeTimeStamp: .invalid
        )

        guard let sampleBuffer = try? CMSampleBuffer(
            imageBuffer: pixelBuffer,
            formatDescription: formatDescription,
            sampleTiming: timingInfo
        ) else {
            fatalError("Unable to create test sample buffer")
        }

        return sampleBuffer
    }
}
