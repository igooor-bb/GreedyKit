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

    @Test("CGImage sample uses source image dimensions")
    func testCGImageSampleUsesSourceImageDimensions() async throws {
        let sut = SampleBufferFactory()

        let sampleBuffer = try #require(await sut.sampleBuffer(
            fromCGImage: makeCGImage(width: 37, height: 19)
        ))
        let imageBuffer = try #require(CMSampleBufferGetImageBuffer(sampleBuffer))

        #expect(CVPixelBufferGetWidth(imageBuffer) == 37)
        #expect(CVPixelBufferGetHeight(imageBuffer) == 19)
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

    private func makeCGImage(width: Int = 1, height: Int = 1) throws -> CGImage {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue
                       | CGImageAlphaInfo.premultipliedFirst.rawValue
        var pixels = Array(repeating: UInt32(0xFFFF0000), count: width * height)

        let image: CGImage? = pixels.withUnsafeMutableBytes { buffer in
            guard let context = CGContext(
                data: buffer.baseAddress,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: width * 4,
                space: colorSpace,
                bitmapInfo: bitmapInfo
            ) else {
                return nil
            }

            return context.makeImage()
        }

        return try #require(image)
    }
}
