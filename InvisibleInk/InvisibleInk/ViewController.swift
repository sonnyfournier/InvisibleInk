//
//  ViewController.swift
//  InvisibleInk
//
//  Created by Sonny Fournier on 21/02/2024.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI elements
    private let invisibleInkView = InvisibleInkView()

    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
    }

    // MARK: - UI setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        invisibleInkView.delegate = self
        // invisibleInkView.showBlurView = true
        view.addSubview(invisibleInkView)
    }

    // MARK: - Constraints setup
    private func setupConstraints() {
        invisibleInkView.translatesAutoresizingMaskIntoConstraints = false
        invisibleInkView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        invisibleInkView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        invisibleInkView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}

extension ViewController: InvisibleInkViewDelegate {

    func contentView(for invisibleInkView: InvisibleInkView) -> UIView {
        let imageView = UIImageView(image: UIImage(named: "Test"))
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 640).isActive = true
        // return imageView

        let contentView = ContentView()
        return contentView
    }

}
