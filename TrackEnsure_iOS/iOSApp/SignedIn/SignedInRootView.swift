//
//  SignedInRootView.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 02.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit

public class SignedInRootView: NiblessView {

    // MARK: - Properties
    // View Model
    let viewModel: SignedInViewModel

    // MARK: - Methods
    public init(viewModel: SignedInViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        styleView()
    }

    deinit { print("DEINIT: ", String(describing: self)) }

    private func styleView() {
        backgroundColor = .systemTeal
    }
}
