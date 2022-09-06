//
//  UIView+Extensions.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import UIKit

extension UIView {
    func constraintsToView(_ uiView: UIView) -> [NSLayoutConstraint] {
        return [
            self.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            self.topAnchor.constraint(equalTo: uiView.topAnchor),
            self.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
        ]
    }
}
