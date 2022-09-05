//
//  GreedyUIImage.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import UIKit
import CoreImage
import AVFoundation

public final class GreedyUIImage: UIView {
    
    @Proxy(\.renderView.preventsCapture)
    public var preventsCapture: Bool
    
    @Proxy(\.renderView.contentGravity)
    public var contentGravity: AVLayerVideoGravity
    
    private lazy var renderView: GreedyRenderView = {
        let view = GreedyRenderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var context: CIContext?
    private let renderQueue = DispatchQueue(label: "greedykit.queue.renderQueue")
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureContext()
        setupView()
    }
    
    private func configureContext() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return
        }
        self.context = CIContext(
            mtlDevice: device,
            options: [
                .name: "GreedyUIImageContext",
                .cacheIntermediates: true,
                .useSoftwareRenderer: false,
                .priorityRequestLow: false
            ]
        )
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(renderView)
        
        NSLayoutConstraint.activate([
            renderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            renderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            renderView.topAnchor.constraint(equalTo: self.topAnchor),
            renderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GreedyUIImage {
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
