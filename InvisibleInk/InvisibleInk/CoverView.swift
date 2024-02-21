//
//  CoverView.swift
//  InvisibleInk
//
//  Created by Sonny Fournier on 21/02/2024.
//

import UIKit

class CoverView: UIView {

    // MARK: - UI elements
    private let contentView = ContentView()
    let particlesView = ParticlesView()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        particlesView.mask = contentView
    }

    // MARK: - UI setup
    private func setupUI() {
        addSubview(contentView)

        addSubview(particlesView)
    }

    // MARK: - Constraints setup
    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        particlesView.translatesAutoresizingMaskIntoConstraints = false
        particlesView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        particlesView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        particlesView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        particlesView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

}
