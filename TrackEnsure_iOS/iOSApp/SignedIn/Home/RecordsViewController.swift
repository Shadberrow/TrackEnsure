//
//  RecordsViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit

public class RecordsViewController: NiblessViewController {

    // MARK: - Properties
    let viewModel: SignedInViewModel

    // MARK: - Methods
    public init(viewModel: SignedInViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    public override func loadView() {
        view = RecordsRootView(viewModel: viewModel, displayType: .normal)
    }
}
