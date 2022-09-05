//
//  DispatchQueue+Extensions.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import Foundation

extension DispatchQueue {
    static func mainAsyncOrNow(execute work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async {
                work()
            }
        }
    }
}
