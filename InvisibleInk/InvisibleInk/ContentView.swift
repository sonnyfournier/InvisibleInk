//
//  ContentView.swift
//  InvisibleInk
//
//  Created by Sonny Fournier on 21/02/2024.
//

import UIKit

class ContentView: UIView {

    // MARK: - UI elements
    private let label = UILabel()

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
        label.text = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
"""
        label.numberOfLines = 0
        addSubview(label)
    }

    // MARK: - Constraints setup
    private func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
    }

}
