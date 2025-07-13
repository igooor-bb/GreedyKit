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
    private static let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue
                                  | CGImageAlphaInfo.premultipliedFirst.rawValue

    // MARK: Properties

    private var pixelBufferPool: CVPixelBufferPool?
    private let context: CIContext

    private var poolGeometry: BufferPoolGeometry
    private let minPoolBuffers: Int

    init(
        maxWidth: Int = 1920,
        maxHeight: Int = 1080,
        minPoolBuffers: Int = 4
    ) {
        self.minPoolBuffers = minPoolBuffers
        self.poolGeometry = BufferPoolGeometry(width: maxWidth, height: maxHeight)
        self.pixelBufferPool = Self.makePool(geometry: poolGeometry, minBuffers: minPoolBuffers)

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
    ) -> CMSampleBuffer? {
        guard let formatDescription = try? CMVideoFormatDescription(
            imageBuffer: pixelBuffer
        ) else {
            return nil
        }
        let timingInfo = CMSampleTimingInfo(
            duration: .invalid,
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
    ) -> CMSampleBuffer? {
        resizePoolIfNeeded(width: cgImage.width, height: cgImage.height)
        guard let pixelBufferPool else {
            return nil
        }

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferPoolCreatePixelBuffer(
            nil,
            pixelBufferPool,
            &pixelBuffer
        )

        guard
            status == kCVReturnSuccess,
            let pixelBuffer
        else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }

        let ciImage = CIImage(cgImage: cgImage)
        let size = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        context.render(
            ciImage,
            to: pixelBuffer,
            bounds: size,
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )

        return sampleBuffer(
            fromPixelBuffer: pixelBuffer,
            presentationTimeStamp: time
        )
    }

    // MARK: Helpers

    private func resizePoolIfNeeded(width: Int, height: Int) {
        guard width > poolGeometry.width || height > poolGeometry.height else { return }

        poolGeometry.width = max(width, poolGeometry.width).aligned64
        poolGeometry.height = max(height, poolGeometry.height).aligned64
        pixelBufferPool = Self.makePool(geometry: poolGeometry, minBuffers: minPoolBuffers)
    }

    private static func makePool(
        geometry: BufferPoolGeometry,
        minBuffers: Int
    ) -> CVPixelBufferPool? {
        let pixelAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: pixelFormat,
            kCVPixelBufferWidthKey as String: geometry.width,
            kCVPixelBufferHeightKey as String: geometry.height,
            kCVPixelBufferBytesPerRowAlignmentKey as String: geometry.width * 4,
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

private struct BufferPoolGeometry {
    var width: Int
    var height: Int
}

private extension Int {
    var aligned64: Int {
        (self + 63) & ~63
    }
}
