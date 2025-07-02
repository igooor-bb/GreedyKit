//
//  AnyViewControllerRepresentable.swift
//  GreedyKitExample
//
//  Created by Igor Belov on 03.07.2025.
//

import SwiftUI
import UIKit

struct AnyViewControllerRepresentable<T: UIViewController>: UIViewControllerRepresentable {
    func makeUIViewController(
        context: Context
    ) -> T { T() }

    func updateUIViewController(
        _ uiViewController: T,
        context: Context
    ) {}
}
