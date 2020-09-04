//
//  RecordsRootView.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit
import UIKit
import Combine

public class RecordsRootView: NiblessView, UITableViewDelegate, UITableViewDataSource {

    public enum DisplayType {
        case normal
        case grouped
    }

    // MARK: - Properties
    // View Model
    let viewModel: RecordsViewModel

    // Subviews
    private var tableView: UITableView!

    private let displayType: DisplayType

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    private var hierarchyNotReady: Bool = true

    // MARK: - Methods
    public init(viewModel: RecordsViewModel, displayType: DisplayType) {
        self.viewModel = viewModel
        self.displayType = displayType
        super.init(frame: .zero)
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else { return }
        setupSubviews()
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false

        viewModel.tableViewReloadSubject
            .sink { [weak self] in self?.tableView.reloadData() }
            .store(in: &subscriptions)
    }

    private func setupSubviews() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
    }
    
    private func constructHierarchy() {
        addSubview(tableView)
    }

    private func activateConstraints() {
        activateConstraintsTableView()
    }

    private func activateConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let top = tableView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }

    // MARK: - UITableView Delegate & Data Source
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableView(tableView, numberOfRowsInSection: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        viewModel.tableView(setupCell: cell, forRowAt: indexPath)
        return cell
    }
}
