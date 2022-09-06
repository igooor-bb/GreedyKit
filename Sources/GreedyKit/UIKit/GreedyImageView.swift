//
//  GreedyImageView.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import UIKit
import CoreImage
import AVFoundation

public final class GreedyImageView: GreedyUIView {
    private var context: CIContext?
    private let renderQueue = DispatchQueue(label: "greedykit.queue.image-render-queue")
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureContext()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureContext() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return
        }
        self.context = CIContext(
            mtlDevice: device,
            options: [
                .name: "GreedyImageViewContext",
                .cacheIntermediates: true,
                .useSoftwareRenderer: false,
                .priorityRequestLow: false
            ]
        )
    }
}

extension GreedyImageView {
    public func setImage(_ cgImage: CGImage) throws {
        guard let buffer = cgImage.sampleBuffer else {
            return
        }
        renderView.enqueueBuffer(buffer)
    }
    
    public func setImage(_ uiImage: UIImage) throws {
        guard let cgImage = uiImage.cgImage else {
            return
        }
        try setImage(cgImage)
    }
    
    public func setImage(_ ciImage: CIImage) throws {
        guard let cgImage = context?.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        try setImage(cgImage)
    }
    
    public func removeImage() {
        renderView.clearLayer()
    }
}
