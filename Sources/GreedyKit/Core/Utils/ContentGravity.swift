//
//  ContentGravity.swift
//  GreedyKit
//
//  Created by Igor Belov on 01.07.2025.
//

import AVFoundation

/// Describes how visual content is fitted into the view’s bounds.
public enum ContentGravity: Sendable {

    /// Preserve aspect ratio, fit inside bounds.
    case fit

    /// Preserve aspect ratio, fill bounds, cropping if necessary.
    case fill

    /// Stretch to fill bounds without preserving aspect ratio.
    case stretch
}

extension ContentGravity {
    var avValue: AVLayerVideoGravity {
        switch self {
        case .fit:
            return .resizeAspect

        case .fill:
            return .resizeAspectFill

        case .stretch:
            return .resize
        }
    }
}
