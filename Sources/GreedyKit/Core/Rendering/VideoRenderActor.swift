//
//  VideoRenderActor.swift
//  GreedyKit
//
//  Created by Igor Belov on 30.06.2025.
//

import AVFoundation
import CoreImage

final actor VideoRenderActor {

    private lazy var sampleBufferFactory = SampleBufferFactory()
    private lazy var videoOutput = AVPlayerItemVideoOutput(
        pixelBufferAttributes: [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
    )

    init() {}

    func attach(to item: AVPlayerItem) async {
        await MainActor.run { [videoOutput] in
            item.add(videoOutput)
        }
    }

    func frame(at time: CMTime) async -> CMSampleBuffer? {
        guard videoOutput.hasNewPixelBuffer(forItemTime: time) else {
            return nil
        }

        var displayTime = CMTime.zero
        guard
            let pixelBuffer = videoOutput.copyPixelBuffer(
                forItemTime: time,
                itemTimeForDisplay: &displayTime
            )
        else {
            return nil
        }

        return await sampleBufferFactory.sampleBuffer(
            fromPixelBuffer: pixelBuffer,
            presentationTimeStamp: time
        )
    }
}
