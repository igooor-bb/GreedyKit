//
//  SampleBufferFactoryTests.swift
//  GreedyKit
//
//  Created by Igor Belov on 14.06.2026.
//

import CoreGraphics
import CoreMedia
import CoreVideo
import Testing

@testable import GreedyKit

@Suite struct SampleBufferFactoryTests {

    @Test("Pixel buffer sample preserves timing")
    func testPixelBufferSamplePreservesTiming() async throws {
        let sut = SampleBufferFactory()
        let presentationTimeStamp = CMTime(value: 3, timescale: 30)
        let duration = CMTime(value: 1, timescale: 30)

        let sampleBuffer = try #require(await sut.sampleBuffer(
            fromPixelBuffer: makePixelBuffer(),
            presentationTimeStamp: presentationTimeStamp,
            duration: duration
        ))

        #expect(sampleBuffer.presentationTimeStamp == presentationTimeStamp)
        #expect(sampleBuffer.duration == duration)
    }

    @Test("CGImage sample preserves timing")
    func testCGImageSamplePreservesTiming() async throws {
        let sut = SampleBufferFactory()
        let presentationTimeStamp = CMTime(value: 5, timescale: 60)
        let duration = CMTime(value: 1, timescale: 60)

        let sampleBuffer = try #require(await sut.sampleBuffer(
            fromCGImage: makeCGImage(),
            presentationTimeStamp: presentationTimeStamp,
            duration: duration
        ))

        #expect(sampleBuffer.presentationTimeStamp == presentationTimeStamp)
        #expect(sampleBuffer.duration == duration)
    }

    private func makePixelBuffer() throws -> CVPixelBuffer {
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            1,
            1,
            kCVPixelFormatType_32BGRA,
            nil,
            &pixelBuffer
        )

        return try #require(pixelBuffer)
    }

    private func makeCGImage() throws -> CGImage {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue
                       | CGImageAlphaInfo.premultipliedFirst.rawValue
        var pixel: UInt32 = 0xFFFF0000

        let context = try #require(CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ))

        return try #require(context.makeImage())
    }
}
