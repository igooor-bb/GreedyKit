//
//  Task+Helpers.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.07.2025.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(milliseconds: Int) async throws {
        try await Self.sleep(nanoseconds: NSEC_PER_MSEC * UInt64(milliseconds))
    }
}
