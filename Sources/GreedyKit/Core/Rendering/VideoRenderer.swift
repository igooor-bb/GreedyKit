//
//  VideoRenderer.swift
//  GreedyKit
//
//  Created by Igor Belov on 30.06.2025.
//

import AVFoundation
import CoreImage

final actor VideoRenderer: VideoRendererProtocol {

    private lazy var sampleBufferFactory = SampleBufferFactory()
    private lazy var videoOutput = AVPlayerItemVideoOutput(
        pixelBufferAttributes: [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
    )
    private var attachedItem: AVPlayerItem?

    init() {}

    func attach(to item: AVPlayerItem) async {
        guard attachedItem !== item else { return }

        attachedItem?.remove(videoOutput)
        item.add(videoOutput)
        attachedItem = item
    }

    func detach() async {
        guard let attachedItem else { return }

        attachedItem.remove(videoOutput)
        self.attachedItem = nil
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
            presentationTimeStamp: displayTime
        )
    }
}
