//
//  ParticlesView.swift
//  InvisibleInk
//
//  Created by Sonny Fournier on 21/02/2024.
//

import UIKit
import SpriteKit

class ParticlesView: UIView {

    // MARK: - UI elements
    private let spriteView = SKView()
    var particlesScene = ParticlesScene()

    // MARK: - Properties
    var particlesColor: UIColor? { didSet { particlesScene.particlesColor = particlesColor } }
    var tappedPoint: CGPoint = .zero

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
        backgroundColor = .clear

        spriteView.allowsTransparency = true
        addSubview(spriteView)

        spriteView.presentScene(particlesScene)

        registerForTraitChanges([UITraitUserInterfaceStyle.self], target: self, action: #selector(handleUserInterfaceStyleUpdate))
    }

    // MARK: - Constraints setup
    private func setupConstraints() {
        spriteView.translatesAutoresizingMaskIntoConstraints = false
        spriteView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        spriteView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        spriteView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        spriteView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    // MARK: - Actions
    @objc private func handleUserInterfaceStyleUpdate() {
        particlesScene.particlesColor = particlesColor != nil ? particlesColor : .label
    }

    // MARK: - Functions
    func startGravity(at point: CGPoint) {
        let convertedPoint = particlesScene.convertPoint(fromView: point)
        particlesScene.gravity.position = convertedPoint
        particlesScene.gravity.strength = -40
        particlesScene.gravity.region = SKRegion(radius: 30)
    }

    func stopGravity() {
        particlesScene.gravity.strength = 0
    }

}
