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
    private var coverMaskView: UIView!

    private var maskedContentView: UIView!
    private var hiddenContentView: UIView!

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

        maskedContentView.mask = canvasMaskView
        canvasMaskView.frame = maskedContentView.bounds
        coverView.particlesView.mask = coverMaskView
    }

    // MARK: UI setup
    private func setupUI() {
        let panRecognizer = UIPanGestureRecognizer(target: canvasMaskView, action: #selector(canvasMaskView.panGestureRecognized))
        addGestureRecognizer(panRecognizer)

        canvasMaskView.delegate = self
        canvasMaskView.backgroundColor = .clear
        canvasMaskView.lineWidth = scratchWidth

        addSubview(coverView)
    }

    // MARK: - Constraints setup
    private func setupConstaints() {
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        coverView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        coverView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        coverView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    // MARK: - Functions
    public func loadViews() {
        guard let maskedContentView = delegate?.contentView(for: self),
              let hiddenContentView = delegate?.contentView(for: self),
              let coverMaskView = delegate?.contentView(for: self) else {
            fatalError("It seems like you forgot to implement the delegate")
        }

        self.maskedContentView = maskedContentView
        addSubview(self.maskedContentView)
        self.maskedContentView.translatesAutoresizingMaskIntoConstraints = false
        self.maskedContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.maskedContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.maskedContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.maskedContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        self.hiddenContentView = hiddenContentView
        self.hiddenContentView.alpha = 0
        addSubview(self.hiddenContentView)
        self.hiddenContentView.translatesAutoresizingMaskIntoConstraints = false
        self.hiddenContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.hiddenContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.hiddenContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.hiddenContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        self.coverMaskView = coverMaskView
        addSubview(self.coverMaskView)
        self.coverMaskView.translatesAutoresizingMaskIntoConstraints = false
        self.coverMaskView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.coverMaskView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.coverMaskView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.coverMaskView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func revealContent() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.hiddenContentView.alpha = 1
        }, completion: { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.canvasMaskView.removeAllLines()
                UIView.animate(withDuration: 2, animations: { [weak self] in
                    self?.hiddenContentView.alpha = 0
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
        if view.scratchedPercentage > 60 { revealContent() }
        coverView.particlesView.startGravity(at: point)
        delegate?.invisibleInkView?(self, didScratchTo: point)
    }

    func canvasViewDidEndDrawing(_ view: CanvasView) {
        coverView.particlesView.stopGravity()
        delegate?.invisibleInkViewDidEndScratching?(self)
    }

}

