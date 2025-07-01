//
//  CoreGraphicsRenderer.swift
//  GreedyKit
//
//  Created by Igor Belov on 01.07.2025.
//

import CoreGraphics
import CoreImage

final actor CoreGraphicsRenderer {
    private let context: CIContext

    init(
        debugName: String,
        cacheIntermediates: Bool = false,
        useSoftwareRenderer: Bool = false,
        priorityRequestLow: Bool = false
    ) {
        let device = MTLCreateSystemDefaultDevice()!
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
