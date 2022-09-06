//
//  ContentControlsView.swift
//  iOSGreedyKit
//
//  Created by Igor Belov on 07.09.2022.
//

import UIKit

protocol ContentControlsDelegate: AnyObject {
    func didChangeToggleValue(to value: Bool)
}

class ContentControlsView: UIView {
    private lazy var toggleView: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let offLabelText = "Protection is OFF"
    private let onLabelText = "Protection is ON"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.offLabelText
        label.textColor = .black
        return label
    }()
    
    weak var delegate: ContentControlsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(toggleView)
        addSubview(label)
        setupLayout()
    }
    
    private func setupLayout() {
        setupToggleView()
        setupLabel()
    }
    
    private func setupToggleView() {
        NSLayoutConstraint.activate([
            toggleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toggleView.topAnchor.constraint(equalTo: self.topAnchor),
            toggleView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        toggleView.addTarget(self, action: #selector(toggleViewValueDidChange(_:)), for: .valueChanged)
    }
    
    private func setupLabel() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: toggleView.trailingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.trailingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor)
        ])
    }
    
    @objc
    private func toggleViewValueDidChange(_ toggleView: UISwitch) {
        self.label.text = toggleView.isOn ? onLabelText : offLabelText
        self.delegate?.didChangeToggleValue(to: toggleView.isOn)
    }
}
