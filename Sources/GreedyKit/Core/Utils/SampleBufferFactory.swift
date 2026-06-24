//
//  SampleBufferFactory.swift
//  GreedyKit
//
//  Created by Igor Belov on 01.07.2025.
//

import AVFoundation
import CoreGraphics
import CoreImage
import CoreVideo

final actor SampleBufferFactory: SampleBufferFactoryProtocol {

    // MARK: Constants

    private static let pixelFormat = kCVPixelFormatType_32BGRA

    // MARK: Properties

    private var pixelBufferPool: CVPixelBufferPool?
    private var poolGeometry: BufferPoolGeometry?
    private let context: CIContext

    private let minPoolBuffers: Int

    init(minPoolBuffers: Int = 4) {
        self.minPoolBuffers = minPoolBuffers

        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("GPU is unavailable on this device")
        }
        self.context = CIContext(
            mtlDevice: device,
            options: [.name: "SampleBufferFactory"]
        )
    }

    // MARK: Interface

    func sampleBuffer(
        fromPixelBuffer pixelBuffer: CVPixelBuffer,
        presentationTimeStamp time: CMTime = .zero,
        duration: CMTime = .invalid
    ) async -> CMSampleBuffer? {
        guard let formatDescription = try? CMVideoFormatDescription(
            imageBuffer: pixelBuffer
        ) else {
            return nil
        }
        let timingInfo = CMSampleTimingInfo(
            duration: duration,
            presentationTimeStamp: time,
            decodeTimeStamp: .invalid
        )
        let sampleBuffer = try? CMSampleBuffer(
            imageBuffer: pixelBuffer,
            formatDescription: formatDescription,
            sampleTiming: timingInfo
        )
        return sampleBuffer
    }

    func sampleBuffer(
        fromCGImage cgImage: CGImage,
        presentationTimeStamp time: CMTime = .zero,
        duration: CMTime = .invalid
    ) async -> CMSampleBuffer? {
        let geometry = BufferPoolGeometry(width: cgImage.width, height: cgImage.height)
        guard let pixelBuffer = makePixelBuffer(geometry: geometry) else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }

        let ciImage = CIImage(cgImage: cgImage)
        let bounds = CGRect(x: 0, y: 0, width: geometry.width, height: geometry.height)
        context.render(
            ciImage,
            to: pixelBuffer,
            bounds: bounds,
            colorSpace: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        )

        return await sampleBuffer(
            fromPixelBuffer: pixelBuffer,
            presentationTimeStamp: time,
            duration: duration
        )
    }

    // MARK: Helpers

    private func makePixelBuffer(geometry: BufferPoolGeometry) -> CVPixelBuffer? {
        guard let pixelBufferPool = pixelBufferPool(for: geometry) else {
            return nil
        }

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferPoolCreatePixelBuffer(
            nil,
            pixelBufferPool,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess else {
            return nil
        }

        return pixelBuffer
    }

    private func pixelBufferPool(for geometry: BufferPoolGeometry) -> CVPixelBufferPool? {
        if poolGeometry == geometry, let pool = pixelBufferPool {
            return pool
        }

        guard let pool = Self.makePool(geometry: geometry, minBuffers: minPoolBuffers) else {
            return nil
        }

        pixelBufferPool = pool
        poolGeometry = geometry
        return pool
    }

    private static func makePool(
        geometry: BufferPoolGeometry,
        minBuffers: Int
    ) -> CVPixelBufferPool? {
        let pixelAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: pixelFormat,
            kCVPixelBufferWidthKey as String: geometry.width,
            kCVPixelBufferHeightKey as String: geometry.height,
            kCVPixelBufferIOSurfacePropertiesKey as String: [:]
        ]
        let poolAttributes: [String: Any] = [
            kCVPixelBufferPoolMinimumBufferCountKey as String: minBuffers
        ]

        var pool: CVPixelBufferPool?
        CVPixelBufferPoolCreate(
            kCFAllocatorDefault,
            poolAttributes as CFDictionary,
            pixelAttributes as CFDictionary,
            &pool
        )
        return pool
    }
}

private struct BufferPoolGeometry: Hashable {
    var width: Int
    var height: Int
}
