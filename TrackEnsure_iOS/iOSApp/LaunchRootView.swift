//
//  LaunchRootView.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 02.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureUIKit
import TrackEnsureKit

public class LaunchRootView: NiblessView {

    // MARK: - Properties
    // View Model
    let viewModel: LaunchViewModel

    // MARK: - Methods
    public init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        styleView()
        loadUserSession()
    }

    deinit { print("DEINIT: ", String(describing: self)) }

    private func styleView() {
        backgroundColor = .systemYellow
    }

    private func loadUserSession() {
        viewModel.loadUserSession()
    }
}
