//
//  GreedyImage.swift
//  GreedyKit
//
//  Created by Igor Belov on 11.09.2022.
//

import SwiftUI
import AVFoundation

private enum SourceType {
    case uiImage(UIImage)
    case cgImage(CGImage)
    case ciImage(CIImage)
}

public struct GreedyImage: UIViewRepresentable {
    private var preventsCapture: Bool
    private var contentGravity: AVLayerVideoGravity
    private let source: SourceType
    
    private init(
        source: SourceType,
        preventsCapture: Bool,
        contentGravity: AVLayerVideoGravity
    ) {
        self.source = source
        self.preventsCapture = preventsCapture
        self.contentGravity = contentGravity
    }
    
    public init(
        _ image: UIImage,
        preventsCapture: Bool,
        contentGravity: AVLayerVideoGravity = .resizeAspect
    ) {
        self.init(
            source: .uiImage(image),
            preventsCapture: preventsCapture,
            contentGravity: contentGravity
        )
    }
    
    public init(
        _ image: CGImage,
        preventsCapture: Bool,
        contentGravity: AVLayerVideoGravity = .resizeAspect
    ) {
        self.init(
            source: .cgImage(image),
            preventsCapture: preventsCapture,
            contentGravity: contentGravity
        )
    }
    
    public init(
        _ image: CIImage,
        preventsCapture: Bool,
        contentGravity: AVLayerVideoGravity = .resizeAspect
    ) {
        self.init(
            source: .ciImage(image),
            preventsCapture: preventsCapture,
            contentGravity: contentGravity
        )
    }
    
    public func makeUIView(context: Context) -> GreedyImageView {
        let view = GreedyImageView()
        switch source {
        case .uiImage(let uiImage):
            view.setImage(uiImage)
        case .cgImage(let cgImage):
            view.setImage(cgImage)
        case .ciImage(let ciImage):
            view.setImage(ciImage)
        }
        return view
    }
    
    public func updateUIView(_ uiView: GreedyImageView, context: Context) {
        uiView.preventsCapture = preventsCapture
        uiView.contentGravity = contentGravity
    }
}
