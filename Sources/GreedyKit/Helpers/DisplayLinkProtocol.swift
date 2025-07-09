//
//  DisplayLinkProtocol.swift
//  GreedyKit
//
//  Created by Igor Belov on 04.07.2025.
//

import UIKit

protocol DisplayLinkProtocol: AnyObject {
    var isPaused: Bool { get set }

    func add(to runLoop: RunLoop, forMode: RunLoop.Mode)
    func invalidate()
}

extension CADisplayLink: DisplayLinkProtocol {}
