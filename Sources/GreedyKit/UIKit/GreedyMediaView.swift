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
    
    lazy var renderView: GreedyRenderView = {
        let view = GreedyRenderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(renderView)
        NSLayoutConstraint.activate(renderView.constraintsToView(self))
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
