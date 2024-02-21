//
//  CoverView.swift
//  InvisibleInk
//
//  Created by Sonny Fournier on 21/02/2024.
//

import UIKit

class CoverView: UIView {

    // MARK: - UI elements
    var contentView: UIView! {
        didSet {
            contentView.isHidden = true
            insertSubview(contentView, at: 0)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    private let blurView = UIVisualEffectView()
    let particlesView = ParticlesView()

    // MARK: - Properties
    var showBlurView: Bool = false {
        didSet {
            blurView.isHidden = !showBlurView
            contentView.isHidden = !showBlurView
            particlesView.particlesColor = showBlurView ? .systemBackground : .label
        }
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI setup
    private func setupUI() {
        blurView.effect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .light ? .light : .dark)
        blurView.isHidden = true
        addSubview(blurView)

        addSubview(particlesView)

        registerForTraitChanges([UITraitUserInterfaceStyle.self], target: self, action: #selector(handleUserInterfaceStyleUpdate))
    }

    // MARK: - Constraints setup
    private func setupConstraints() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        particlesView.translatesAutoresizingMaskIntoConstraints = false
        particlesView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        particlesView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        particlesView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        particlesView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    // MARK: - Actions
    @objc private func handleUserInterfaceStyleUpdate() {
        guard showBlurView else { return }

        blurView.effect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .light ? .light : .dark)
    }

}
