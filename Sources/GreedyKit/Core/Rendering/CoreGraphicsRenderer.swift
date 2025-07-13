//
//  CoreGraphicsRenderer.swift
//  GreedyKit
//
//  Created by Igor Belov on 01.07.2025.
//

import CoreGraphics
import CoreImage

final class CoreGraphicsRenderer: CoreGraphicsRendererProtocol {
    private let context: CIContext

    init(
        debugName: String,
        cacheIntermediates: Bool = false,
        useSoftwareRenderer: Bool = false,
        priorityRequestLow: Bool = false
    ) {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("GPU is unavailable on this device")
        }

        context = CIContext(
            mtlDevice: device,
            options: [
                .name: "\(debugName)Context",
                .cacheIntermediates: cacheIntermediates,
                .useSoftwareRenderer: useSoftwareRenderer,
                .priorityRequestLow: priorityRequestLow
            ]
        )
    }

    func cgImage(from ciImage: CIImage) async -> CGImage? {
        context.createCGImage(ciImage, from: ciImage.extent)
    }
}
