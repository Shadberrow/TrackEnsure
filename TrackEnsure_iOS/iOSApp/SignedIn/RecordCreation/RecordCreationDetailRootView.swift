//
//  RecordCreationDetailRootView.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit
import UIKit
import Combine

class RecordCreationDetailRootView: NiblessView {

    // MARK: - Properties
    // View Model
    let viewModel: RecordCreationViewModel

    // Subviews
    private var locationAddress: UILabel!
    private var actionButton: UIButton!

    private var hierarchyNotReady: Bool = true

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Methods
    init(viewModel: RecordCreationViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else { return }
        setupSubviews()
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false

        combineViewModel()
    }

    private func setupSubviews() {
        locationAddress = UILabel()
        locationAddress.textColor = .label
        locationAddress.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        actionButton = UIButton(type: .system)
        actionButton.setTitle("Next", for: .normal)
        actionButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        actionButton.backgroundColor = .systemBlue
        actionButton.layer.cornerRadius = 8
        actionButton.tintColor = .white
        actionButton.addTarget(self, action: #selector(handleAciton), for: .touchUpInside)
    }

    private func constructHierarchy() {
        addSubview(locationAddress)
        addSubview(actionButton)
    }

    private func activateConstraints() {
        activateConstraintsLocationAddress()
        activateConstraintsActionButton()
    }

    private func activateConstraintsLocationAddress() {
        locationAddress.translatesAutoresizingMaskIntoConstraints = false
        let top = locationAddress.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)
        let leading = locationAddress.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        NSLayoutConstraint.activate([top, leading])
    }

    private func activateConstraintsActionButton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        let top = actionButton.topAnchor.constraint(equalTo: locationAddress.bottomAnchor, constant: 12)
        let height = actionButton.heightAnchor.constraint(equalToConstant: 44)
        let width = actionButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        let centerX = actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        NSLayoutConstraint.activate([top, height, width, centerX])
    }

    private func combineViewModel() {
        viewModel.addressLabel.assign(to: \.text, on: locationAddress).store(in: &subscriptions)
    }

    @objc private func handleAciton() {
        viewModel.expandDetailView()
    }
}
