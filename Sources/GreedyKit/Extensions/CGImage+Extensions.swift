//
//  CGImage+Extensions.swift
//  GreedyKit
//
//  Created by Igor Belov on 03.09.2022.
//

import Foundation
import AVFoundation
import CoreImage

extension CGImage {
    var cvPixelBuffer: CVPixelBuffer? {
        var cvPixelBuffer: CVPixelBuffer?
        let ioSurfaceProperties = NSMutableDictionary()
        let options = NSMutableDictionary()

        options.setObject(ioSurfaceProperties, forKey: kCVPixelBufferIOSurfacePropertiesKey as NSString)

        CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(self.width),
            Int(self.height),
            kCVPixelFormatType_32ARGB,
            options as CFDictionary,
            &cvPixelBuffer
        )

        guard let cvPixelBuffer = cvPixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(cvPixelBuffer, [])
        defer { CVPixelBufferUnlockBaseAddress(cvPixelBuffer, []) }

        let baseAddress = CVPixelBufferGetBaseAddress(cvPixelBuffer)
        guard let context = CGContext(
            data: baseAddress,
            width: Int(self.width),
            height: Int(self.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(cvPixelBuffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        ) else {
            return nil
        }

        let frame = CGRect(
            origin: .zero,
            size: CGSize(width: self.width, height: self.height)
        )
        context.clear(frame)
        context.draw(self, in: frame)

        return cvPixelBuffer
    }

    var sampleBuffer: CMSampleBuffer? {
        guard let cvPixelBuffer = self.cvPixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(cvPixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(cvPixelBuffer, .readOnly) }

        guard let formatDescription = try? CMVideoFormatDescription(imageBuffer: cvPixelBuffer) else {
            return nil
        }

        let timingInfo = CMSampleTimingInfo(
            duration: CMTime(value: 1, timescale: 30),
            presentationTimeStamp: .zero,
            decodeTimeStamp: .invalid
        )

        return try? CMSampleBuffer(
            imageBuffer: cvPixelBuffer,
            formatDescription: formatDescription,
            sampleTiming: timingInfo
        )
    }
}
