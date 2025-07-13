//
//  CoreGraphicsRendererProtocol.swift
//  GreedyKit
//
//  Created by Igor Belov on 13.07.2025.
//

import CoreImage

protocol CoreGraphicsRendererProtocol {
    func cgImage(from ciImage: CIImage) async -> CGImage?
}
