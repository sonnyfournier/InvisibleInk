//
//  ParticlesScene.swift
//  InvisibleInk
//
//  Created by Sonny Fournier on 21/02/2024.
//

import Foundation
import SpriteKit

class ParticlesScene: SKScene {

    // MARK: - Properties
    private let emitterNode = SKEmitterNode(fileNamed: "MyParticle.sks")!
    let gravity = SKFieldNode.radialGravityField()

    // MARK: - Life cycle
    override func sceneDidLoad() {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
        backgroundColor = .clear

        emitterNode.particleColorSequence = nil
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleColor = .label
        emitterNode.particleSize = CGSize(width: 30, height: 30)
        emitterNode.position = CGPoint(x: frame.midX, y: frame.midY)
        emitterNode.advanceSimulationTime(5)
        addChild(emitterNode)

        gravity.falloff = -1
        gravity.strength = 0
        gravity.animationSpeed = 0.2
        gravity.region = SKRegion(radius: 25)
        addChild(gravity)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)

        if let bounds = view?.bounds {
            emitterNode.particlePositionRange = CGVector(dx: bounds.width, dy: bounds.height)
            emitterNode.particleBirthRate = ((bounds.width + bounds.height) / 2) * 5
        }
    }

}
