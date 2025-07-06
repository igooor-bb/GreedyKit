//
//  RenderViewProtocol.swift
//  GreedyKit
//
//  Created by Igor Belov on 04.07.2025.
//

import AVFoundation
import UIKit

protocol RenderViewProtocol: UIView {
    var preventsCapture: Bool { get set }
    var contentGravity: AVLayerVideoGravity { get set }

    func enqueueBuffer(_ buffer: CMSampleBuffer) async
    func clearLayer() async
}
