//
//  SampleBufferFactoryProtocol.swift
//  GreedyKit
//
//  Created by Igor Belov on 11.07.2025.
//

import AVFoundation
import CoreImage

protocol SampleBufferFactoryProtocol: Actor {
    func sampleBuffer(
        fromPixelBuffer pixelBuffer: CVPixelBuffer,
        presentationTimeStamp time: CMTime,
        duration: CMTime
    ) async -> CMSampleBuffer?

    func sampleBuffer(
        fromCGImage cgImage: CGImage,
        presentationTimeStamp time: CMTime,
        duration: CMTime
    ) async -> CMSampleBuffer?
}

extension SampleBufferFactoryProtocol {
    func sampleBuffer(
        fromPixelBuffer pixelBuffer: CVPixelBuffer,
        presentationTimeStamp time: CMTime = .invalid,
        duration: CMTime = .zero
    ) async -> CMSampleBuffer? {
        await sampleBuffer(
            fromPixelBuffer: pixelBuffer,
            presentationTimeStamp: time,
            duration: duration
        )
    }

    func sampleBuffer(
        fromCGImage cgImage: CGImage,
        presentationTimeStamp time: CMTime = .invalid,
        duration: CMTime = .zero
    ) async -> CMSampleBuffer? {
        await sampleBuffer(
            fromCGImage: cgImage,
            presentationTimeStamp: time,
            duration: duration
        )
    }
}
