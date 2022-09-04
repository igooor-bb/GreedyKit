//
//  GreedyContentMode.swift
//  GreedyKit
//
//  Created by Igor Belov on 03.09.2022.
//

import AVFoundation

public enum GreedyContentMode {
    case resizeAspect
    case resizeAspectFill
    case resize

    internal var toGravity: AVLayerVideoGravity {
        switch self {
        case .resizeAspect:
            return .resizeAspect
        case .resizeAspectFill:
            return .resizeAspectFill
        case .resize:
            return .resize
        }
    }

    static internal func fromGravity(_ gravity: AVLayerVideoGravity) -> Self {
        switch gravity {
        case .resizeAspect:
            return .resizeAspect
        case .resizeAspectFill:
            return .resizeAspectFill
        case .resize:
            return .resize
        default:
            fatalError("Unsupported video gravity")
        }
    }
}
