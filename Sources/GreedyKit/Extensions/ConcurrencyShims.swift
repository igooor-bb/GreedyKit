//
//  ConcurrencyShims.swift
//  GreedyKit
//
//  Created by Igor Belov on 30.06.2025.
//

import AVFoundation

/// Safe because after attachment to an `AVPlayerItem`,
/// we only access the output's read-only methods from a single actor.
/// No concurrent mutation occurs in our usage.
extension AVPlayerItemVideoOutput: @unchecked @retroactive Sendable {}

/// Safe because `CMSampleBuffer` is immutable after creation in our usage.
/// We do not modify or share underlying storage across threads.
extension CMSampleBuffer: @unchecked @retroactive Sendable {}
