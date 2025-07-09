//
//  RenderViewProtocol+Extensions.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import UIKit

extension RenderViewProtocol {
    func configure(in superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        superview.backgroundColor = .clear
        superview.addSubview(self)

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
}
