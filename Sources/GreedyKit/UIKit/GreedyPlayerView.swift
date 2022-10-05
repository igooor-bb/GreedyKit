//
//  GreedyPlayerView.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import UIKit
import Combine
import AVFoundation

public final class GreedyPlayerView: GreedyMediaView {
    public var player: AVPlayer? {
        didSet {
            addPlayerItemObserver()
        }
    }
    
    private var playerItemObserver: AnyCancellable?
    private var context: CIContext?
    private let renderQueue = DispatchQueue(label: "greedykit.queue.video-render-queue")
    
    private lazy var videoOutput: AVPlayerItemVideoOutput = {
        let settings = [String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32BGRA]
        return AVPlayerItemVideoOutput(pixelBufferAttributes: settings)
    }()
    
    private lazy var displayLink = CADisplayLink(
        target: self,
        selector: #selector(displayLinkDidRefresh(link:))
    )
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureContext()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        displayLink.invalidate()
        playerItemObserver?.cancel()
    }
    
    private func configureContext() {
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        self.context = CIContext(
            mtlDevice: device,
            options: [
                .name: "GreedyPlayerViewContext",
                .cacheIntermediates: false,
                .useSoftwareRenderer: false,
                .priorityRequestLow: false
            ]
        )
    }
    
    public override func didMoveToSuperview() {
        initializeDisplayLink()
    }
    
    private func initializeDisplayLink() {
        self.displayLink.add(to: .current, forMode: .common)
        self.displayLink.isPaused = true
    }
    
    @objc
    private func displayLinkDidRefresh(link: CADisplayLink) {
        guard let player = player else { return }
        let itemTime = player.currentTime()
        if videoOutput.hasNewPixelBuffer(forItemTime: itemTime) {
            var presentationItemTime: CMTime = .zero
            if let pixelBuffer = videoOutput.copyPixelBuffer(
                forItemTime: itemTime,
                itemTimeForDisplay: &presentationItemTime
            ) {
                createSampleBuffer(from: pixelBuffer)
            }
        }
    }
    
    private func createSampleBuffer(from pixelBuffer: CVPixelBuffer) {
        autoreleasepool {
            renderQueue.async {
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                if let cgImage = self.context?.createCGImage(ciImage, from: ciImage.extent),
                   let buffer = cgImage.sampleBuffer {
                    self.renderView.enqueueBuffer(buffer)
                }
            }
        }
    }
    
    private func addPlayerItemObserver() {
        guard let player = player else { return }
        playerItemObserver = player.publisher(for: \.currentItem)
            .compactMap { $0 }
            .sink { [weak self] playerItem in
                guard let self = self else { return }
                playerItem.add(self.videoOutput)
                self.displayLink.isPaused = false
            }
    }
}
