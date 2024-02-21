//
//  CanvasView.swift
//  InvisibleInk
//
//  Created by Sonny Fournier on 21/02/2024.
//

import UIKit

protocol CanvasViewDelegate: AnyObject {
    func canvasViewDidStartDrawing(_ view: CanvasView, at point: CGPoint)
    func canvasViewDidAddLine(_ view: CanvasView, to point: CGPoint)
    func canvasViewDidEndDrawing(_ view: CanvasView)
}

struct PathData {
    var path: CGMutablePath
    var points: [CGPoint]
}

class CanvasView: UIView {

    // MARK: Properties
    weak var delegate: CanvasViewDelegate?
    var lineWidth: CGFloat = 10
    private var currentPath: CGMutablePath?
    private var currentPoints: [CGPoint] = []

    private var timer: Timer?
    var scratchedPercentage: CGFloat = 0

    private var savedPaths: [PathData] = []

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized)))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Life cycle
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(lineWidth)
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setShadow(offset: .zero, blur: 5, color: UIColor.black.cgColor)

        for path in savedPaths.compactMap({ $0.path }) + [currentPath].compactMap({$0}) {
            context?.addPath(path)
            context?.strokePath()
        }
    }

    // MARK: Actions
    @objc func panGestureRecognized(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self)

        switch recognizer.state {
        case .began:
            beginPath(at: location)
            delegate?.canvasViewDidStartDrawing(self, at: location)
        case .changed:
            addLine(to: location)
            calculScratchedPercentage()
            delegate?.canvasViewDidAddLine(self, to: location)
        default:
            closePath()
            delegate?.canvasViewDidEndDrawing(self)

            // TODO: Is the user is "drawing" another line then invalidate the timer
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let self = self else { return }
                self.timer = Timer.scheduledTimer(timeInterval: 0.03, target: self,
                                                  selector: #selector(removeLinePart), userInfo: nil, repeats: true)
            }
        }
    }

    @objc private func removeLinePart() {
        guard savedPaths.count > 0, savedPaths.first?.points.count ?? 0 > 0 else {
            timer?.invalidate()
            if savedPaths.count > 0 { savedPaths.removeFirst() }
            setNeedsDisplay()

            return
        }

        savedPaths[0].points.removeFirst()

        let updatedPath = CGMutablePath()
        for (index, point) in savedPaths[0].points.enumerated() {
            if index == 0 {
                updatedPath.move(to: point)
            } else {
                updatedPath.addLine(to: point)
            }
        }

        savedPaths[0].path = updatedPath
        setNeedsDisplay()
    }

    // MARK: Functions
    private func beginPath(at point: CGPoint) {
        currentPath = CGMutablePath()
        currentPath?.move(to: point)
        currentPoints.append(point)
    }

    private func addLine(to point: CGPoint) {
        currentPath?.addLine(to: point)
        currentPoints.append(point)
        setNeedsDisplay()
    }

    private func closePath() {
        if let currentPath = currentPath { savedPaths.append(PathData(path: currentPath, points: currentPoints)) }
        currentPoints = []
        currentPath = nil
        setNeedsDisplay()
    }

    func removeAllLines() {
        timer?.invalidate()
        savedPaths = []
        currentPath = nil
        setNeedsDisplay()
    }

    private func calculScratchedPercentage() {
        var percentage: CGFloat = calculPathArea(from: currentPoints)

        for savedPath in savedPaths { percentage += calculPathArea(from: savedPath.points) }

        scratchedPercentage = percentage
    }

    func pointDistance(from firstPoint: CGPoint, to secondPoint: CGPoint) -> CGFloat {
        return sqrt((firstPoint.x - secondPoint.x) * (firstPoint.x - secondPoint.x) + (firstPoint.y - secondPoint.y) * (firstPoint.y - secondPoint.y))
    }

    private func calculPathArea(from points: [CGPoint]) -> CGFloat {
        var insidePoints = points
        // Remove points that are out of the bounds of the view
        insidePoints.removeAll(where: { $0.y < 0 || $0.x < 0 || $0.y > bounds.height || $0.x > bounds.width })

        // Remove points that are too close to each others
        for firstIndex in 0..<insidePoints.count {
            guard firstIndex + 1 < insidePoints.count else { break }
            for secondIndex in (firstIndex + 1)..<insidePoints.count {
                guard insidePoints.count > secondIndex else { break }
                if pointDistance(from: insidePoints[secondIndex], to: insidePoints[firstIndex]) < lineWidth / 2 {
                    insidePoints.remove(at: secondIndex)
                }
            }
        }

        let circleArea = CGFloat.pi * (lineWidth / 2) * (lineWidth / 2)
        let viewArea = bounds.width * bounds.height
        let pathArea = circleArea * CGFloat(insidePoints.count)

        return (pathArea / viewArea) * 100
    }

}
