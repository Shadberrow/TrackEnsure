//
//  RecordCreationViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit

public class RecordCreationViewController: NiblessNavigationController {

    // MARK: - Properties
    let viewModel: RecordCreationViewModel

    // MARK: - Methods
    public init(viewModel: RecordCreationViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    }
}
