//
//  InvisibleInkView.swift
//  InvisibleInk
//
//  Created by Sonny Fournier on 21/02/2024.
//

import UIKit

/// The InvisibleInkViewDelegate interface
@objc protocol InvisibleInkViewDelegate: AnyObject {

    /// The content view of the invisible ink view.
    /// It is initialy covered and is revealed after scratching the view.
    ///
    /// - Parameter invisibleInkView: The view that asks for the content view.
    /// - Returns: The method should return a content view for the invisible ink view
    func contentView(for invisibleInkView: InvisibleInkView) -> UIView

    /// Gets called when scratching starts
    ///
    /// - Parameters:
    ///   - view: The invisible ink view
    ///   - point: The point at which the scratches started. In the scratch card coordinate system
    @objc optional func invisibleInkView(_ invisibleInkView: InvisibleInkView, didStartScratchingAt point: CGPoint)

    /// Called when scratches are in progress
    ///
    /// - Parameters:
    ///   - view: The invisible ink view
    ///   - point: The point to which the scratching finger moved. In the scratch card coordinate system
    @objc optional func invisibleInkView(_ invisibleInkView: InvisibleInkView, didScratchTo point: CGPoint)

    /// Called when current scratches stop (user lifts his finger)
    ///
    /// - Parameter view: The invisible ink view
    @objc optional func invisibleInkViewDidEndScratching(_ invisibleInkView: InvisibleInkView)

}

/// The invisibleInkView
class InvisibleInkView: UIView {

    // MARK: - UI elements
    private let coverView = CoverView()
    private let coverContainerView = UIView()
    private let maskedContentContainerView = UIView()
    private let hiddenContentContainerView = UIView()
    private let canvasMaskView = CanvasView()

    // MARK: Properties
    weak var delegate: InvisibleInkViewDelegate? { didSet { loadViews() } }
    var scratchWidth: CGFloat = 50 { didSet { canvasMaskView.lineWidth = scratchWidth } }

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupConstaints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()

        canvasMaskView.frame = maskedContentContainerView.bounds
    }

    // MARK: UI setup
    private func setupUI() {
        let panRecognizer = UIPanGestureRecognizer(target: canvasMaskView, action: #selector(canvasMaskView.panGestureRecognized))
        addGestureRecognizer(panRecognizer)

        canvasMaskView.delegate = self
        canvasMaskView.backgroundColor = .clear
        canvasMaskView.lineWidth = scratchWidth

        addSubview(coverContainerView)
        coverContainerView.addSubview(coverView)

        maskedContentContainerView.mask = canvasMaskView
        addSubview(maskedContentContainerView)

        hiddenContentContainerView.alpha = 0
        addSubview(hiddenContentContainerView)
    }

    // MARK: - Constraints setup
    private func setupConstaints() {
        coverContainerView.translatesAutoresizingMaskIntoConstraints = false
        coverContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        coverContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        coverContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        coverContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        coverView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        coverView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        coverView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        maskedContentContainerView.translatesAutoresizingMaskIntoConstraints = false
        maskedContentContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        maskedContentContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        maskedContentContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        maskedContentContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        hiddenContentContainerView.translatesAutoresizingMaskIntoConstraints = false
        hiddenContentContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        hiddenContentContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        hiddenContentContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        hiddenContentContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    // MARK: - Functions
    public func loadViews() {
        guard let maskedContentView = delegate?.contentView(for: self),
              let hiddenContentView = delegate?.contentView(for: self) else {
            fatalError("It seems like you forgot to implement the delegate")
        }

        maskedContentContainerView.addSubview(maskedContentView)
        maskedContentView.translatesAutoresizingMaskIntoConstraints = false
        maskedContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        maskedContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        maskedContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        maskedContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        hiddenContentContainerView.addSubview(hiddenContentView)
        hiddenContentView.translatesAutoresizingMaskIntoConstraints = false
        hiddenContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        hiddenContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        hiddenContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        hiddenContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    // TODO: Rename
    func test() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.hiddenContentContainerView.alpha = 1
        }, completion: { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.canvasMaskView.removeAllLines()
                UIView.animate(withDuration: 2, animations: { [weak self] in
                    self?.hiddenContentContainerView.alpha = 0
                })
            }
        })
    }

}

extension InvisibleInkView: CanvasViewDelegate {

    func canvasViewDidStartDrawing(_ view: CanvasView, at point: CGPoint) {
        delegate?.invisibleInkView?(self, didStartScratchingAt: point)
    }

    func canvasViewDidAddLine(_ view: CanvasView, to point: CGPoint) {
        if view.scratchedPercentage > 60 { test() }
        coverView.particlesView.startGravity(at: point)
        delegate?.invisibleInkView?(self, didScratchTo: point)
    }

    func canvasViewDidEndDrawing(_ view: CanvasView) {
        coverView.particlesView.stopGravity()
        delegate?.invisibleInkViewDidEndScratching?(self)
    }

}

