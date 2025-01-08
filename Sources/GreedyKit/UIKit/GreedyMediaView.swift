//
//  GreedyMediaView.swift
//  GreedyKit
//
//  Created by Igor Belov on 05.09.2022.
//

import UIKit
import AVFoundation

public class GreedyMediaView: UIView {

    @Proxy(\.renderView.preventsCapture)
    public var preventsCapture: Bool

    @Proxy(\.renderView.contentGravity)
    public var contentGravity: AVLayerVideoGravity

    let renderView: GreedyRenderView

    public override init(frame: CGRect) {
        renderView = GreedyRenderView()

        super.init(frame: frame)
        setupView()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        renderView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(renderView)
        NSLayoutConstraint.activate(renderView.constraintsToView(self))
    }
}
